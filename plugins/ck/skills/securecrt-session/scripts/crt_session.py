#!/usr/bin/env python3
"""List, create or update SecureCRT sessions by editing the session .ini files.

  crt_session.py list [FOLDER]
  crt_session.py put FOLDER NAME[=HOST[=DESCRIPTION]]... [--user U] [--credential C] [--template T]
  crt_session.py test

FOLDER is matched loosely against the folders under <config>/Sessions:
"lab/site-a/ssh" finds "1. example-lab/site-a/ssh".
"""

import argparse
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

FOLDER_DATA = "__FolderData__.ini"
DESC = re.compile(r'^Z:"Description"=[0-9a-f]{8}((?:\r?\n [^\r\n]*)*)', re.MULTILINE)
LIST = re.compile(
    r'^Z:"Session List V2"=[0-9a-f]{8}((?:\r?\n [^\r\n]*)*)', re.MULTILINE
)


def config_dir() -> Path:
    if env := os.environ.get("SECURECRT_CONFIG"):
        return Path(env)
    # shortcut: macOS only (`defaults`), add the Windows registry / Linux path when needed
    out = subprocess.run(
        ["defaults", "read", "com.vandyke.SecureCRT", "Config Path"],
        capture_output=True,
        text=True,
        check=False,
    ).stdout.strip()
    return Path(
        out or Path.home() / "Library/Application Support/VanDyke/SecureCRT/Config"
    )


def norm(s: str) -> str:
    return re.sub(r"[^a-z0-9]", "", s.lower())


def find_folder(sessions: Path, query: str) -> Path:
    q = [n for p in query.strip("/").split("/") if (n := norm(p))]
    hits = []
    for d in sorted(p for p in sessions.rglob("*") if p.is_dir()):
        parts = [norm(p) for p in d.relative_to(sessions).parts]
        if len(q) <= len(parts) and all(a in b for a, b in zip(q, parts[-len(q) :])):
            hits.append(d)
    if len(hits) != 1:
        found = "".join(f"\n  {h.relative_to(sessions)}" for h in hits) or " none"
        sys.exit(f"folder {query!r} matches {len(hits)} folders:{found}")
    return hits[0]


def read(path: Path) -> str:
    return path.read_bytes().decode("utf-8")  # keeps the BOM and the line endings


def get(text: str, key: str) -> str:
    m = re.search(rf'^[A-Z]:"{re.escape(key)}"=([^\r\n]*)', text, re.MULTILINE)
    return m.group(1) if m else ""


def put_key(text: str, key: str, value: str, required: bool = True) -> str:
    new, n = re.subn(
        rf'^([A-Z]:"{re.escape(key)}"=)[^\r\n]*',
        lambda m: m.group(1) + value,
        text,
        flags=re.MULTILINE,
    )
    if n > 1 or (required and n == 0):
        sys.exit(f'key "{key}" found {n} times')
    return new


def description(text: str) -> str:
    m = DESC.search(text)
    return (
        " / ".join(ln.strip() for ln in m.group(1).splitlines() if ln.strip())
        if m
        else ""
    )


def put_desc(text: str, desc: str) -> str:
    nl = "\r\n" if "\r\n" in text else "\n"
    block = (
        f'Z:"Description"=00000001{nl} {desc}' if desc else 'Z:"Description"=00000000'
    )
    new, n = DESC.subn(lambda _m: block, text)
    if n != 1:
        sys.exit(f'key "Description" found {n} times')
    return new


def session_files(folder: Path) -> list[Path]:
    return sorted(p for p in folder.glob("*.ini") if p.name != FOLDER_DATA)


def register(folder: Path, names: list[str]) -> None:
    """Add `names` to the folder's session list (order in the SecureCRT tree)."""
    f = folder / FOLDER_DATA
    if not names or not f.is_file():
        return
    text = read(f)
    m = LIST.search(text)
    if not m:
        sys.exit(f"{f}: no Session List V2")
    nl = "\r\n" if "\r\n" in text else "\n"
    have = [ln[1:] for ln in m.group(1).splitlines() if ln]
    every = have + [n for n in names if n not in have]
    block = f'Z:"Session List V2"={len(every):08x}' + "".join(
        f"{nl} {n}" for n in every
    )
    f.write_bytes((text[: m.start()] + block + text[m.end() :]).encode("utf-8"))


def put(
    cfg: Path,
    folder_q: str,
    specs: list[str],
    user: str | None,
    credential: str | None,
    template: str | None,
) -> None:
    sessions = cfg / "Sessions"
    folder = find_folder(sessions, folder_q)
    if credential and not (cfg / "Credentials" / f"{credential}.ini").is_file():
        have = ", ".join(sorted(p.stem for p in (cfg / "Credentials").glob("*.ini")))
        sys.exit(f"no credential {credential!r}; have: {have}")
    created = []
    for spec in specs:
        name, host, desc = (spec.split("=", 2) + [None, None])[:3]
        host = host or None  # NAME==DESCRIPTION: the description alone
        path = folder / f"{name}.ini"
        cred = credential
        if path.exists():
            text, what = read(path), "updated"
        else:
            if not host:
                sys.exit(f"{name}: not in {folder.name}; a new session needs NAME=HOST")
            src = (
                sessions / f"{template}.ini"
                if template and "/" in template
                else folder / f"{template}.ini"
                if template
                else next(iter(session_files(folder)), None)
            )
            if src is None or not src.is_file():
                sys.exit(f"no template session ({src}); give --template")
            text, what = read(src), f"created from {src.stem}"
            # the template's saved password and description belong to another host
            for key, value in (
                ("Password", ""),
                ("Password V2", ""),
                ("Session Password Saved", "00000000"),
            ):
                text = put_key(text, key, value, required=False)
            desc = desc or ""
            if cred is None and user and user != get(text, "Username"):
                cred = ""  # the template's credential is for another user
            created.append(name)
        for key, value in (
            ("Hostname", host),
            ("Username", user),
            ("Credential Title", cred),
        ):
            if value is not None:
                text = put_key(text, key, value)
        if desc is not None:
            text = put_desc(text, desc)
        path.write_bytes(text.encode("utf-8"))
        print(f"{name}: {what}; {show(text)}")
    register(folder, created)
    print(f"folder: {folder.relative_to(sessions)}")


def show(text: str) -> str:
    cred = get(text, "Credential Title") or "-"
    saved = get(text, "Session Password Saved").endswith("1")
    return (
        f"{get(text, 'Protocol Name')} {get(text, 'Username') or '-'}@{get(text, 'Hostname')}"
        f" credential={cred}{' password-saved' if saved else ''} {description(text)}"
    ).rstrip()


def list_(cfg: Path, folder_q: str | None) -> None:
    sessions = cfg / "Sessions"
    if not folder_q:
        for d in sorted(p for p in sessions.rglob("*") if p.is_dir()):
            print(f"{len(session_files(d)):3}  {d.relative_to(sessions)}")
        return
    folder = find_folder(sessions, folder_q)
    print(f"folder: {folder.relative_to(sessions)}")
    for p in session_files(folder):
        print(f"{p.stem}: {show(read(p))}")


def test() -> None:
    with tempfile.TemporaryDirectory() as tmp:
        cfg = Path(tmp)
        folder = cfg / "Sessions" / "1. lab x" / "ssh"
        folder.mkdir(parents=True)
        (cfg / "Credentials").mkdir()
        (cfg / "Credentials" / "labroot.ini").write_text("x")
        (folder / "a.ini").write_bytes(
            '\ufeffD:"Is Session"=00000001\nS:"Password V2"=02:abcd\nS:"Credential Title"=labroot\n'
            'D:"Session Password Saved"=00000001\nS:"Username"=labroot\n'
            'Z:"Description"=00000001\n old\nS:"Protocol Name"=SSH2\nS:"Hostname"=a.example\n'.encode()
        )
        (folder / FOLDER_DATA).write_bytes(
            '\ufeffD:"Is Expanded"=00000001\nZ:"Session List V2"=00000001\n a\n'
            'Z:"Folder List V2"=00000000\n'.encode()
        )
        put(cfg, "1.lab/ssh", ["b=10.0.0.2=vm b", "c=10.0.0.3"], "root", None, None)
        b = read(folder / "b.ini")
        assert b.startswith("\ufeff") and get(b, "Hostname") == "10.0.0.2"
        assert get(b, "Username") == "root" and get(b, "Credential Title") == ""
        assert (
            get(b, "Password V2") == ""
            and get(b, "Session Password Saved") == "00000000"
        )
        assert description(b) == "vm b" and description(read(folder / "c.ini")) == ""
        data = read(folder / FOLDER_DATA)
        assert 'V2"=00000003\n a\n b\n c\nZ:"Folder List V2"' in data, data
        put(
            cfg, "lab/ssh", ["b=10.0.0.9"], None, "labroot", None
        )  # update: only what is given
        b = read(folder / "b.ini")
        assert (
            get(b, "Hostname"),
            get(b, "Username"),
            get(b, "Credential Title"),
            description(b),
        ) == ("10.0.0.9", "root", "labroot", "vm b")
        assert read(folder / FOLDER_DATA) == data
        put(cfg, "lab/ssh", ["b==new text"], None, None, None)
        b = read(folder / "b.ini")
        assert (get(b, "Hostname"), description(b)) == ("10.0.0.9", "new text")
        for bad in (["zz"], ["b"]):  # new session with no host; unknown credential
            try:
                put(cfg, "ssh", bad, None, None if bad == ["zz"] else "nope", None)
            except SystemExit:
                continue
            raise AssertionError(bad)
    print("ok")


def main() -> None:
    p = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawTextHelpFormatter
    )
    sub = p.add_subparsers(dest="cmd", required=True)
    p_list = sub.add_parser("list")
    p_list.add_argument("folder", nargs="?")
    p_put = sub.add_parser("put")
    p_put.add_argument("folder")
    p_put.add_argument("specs", nargs="+", metavar="NAME[=HOST[=DESCRIPTION]]")
    p_put.add_argument("--user")
    p_put.add_argument(
        "--credential", help='title in <config>/Credentials; "" clears it'
    )
    p_put.add_argument(
        "--template", help="session to copy: a name in FOLDER, or a path under Sessions"
    )
    sub.add_parser("test")
    a = p.parse_args()
    if a.cmd == "test":
        test()
    elif a.cmd == "list":
        list_(config_dir(), a.folder)
    else:
        put(config_dir(), a.folder, a.specs, a.user, a.credential, a.template)


if __name__ == "__main__":
    main()
