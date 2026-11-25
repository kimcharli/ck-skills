---
name: securecrt-session
description: Create, update or list SecureCRT sessions (host, user, credential, description) by editing the session .ini files with one script call. Use when the user says "add a SecureCRT session", "add X in securecrt <folder>", "update the securecrt session", "change the session host/user", or names a SecureCRT session folder such as "lab/site-a/ssh".
---

# SecureCRT sessions

One script does the work: `scripts/crt_session.py` (Python 3, standard library only). Do
not explore the config by hand, and do not write session files yourself.

```sh
python3 "$SKILL_DIR/scripts/crt_session.py" list                  # every folder, with its session count
python3 "$SKILL_DIR/scripts/crt_session.py" list "lab/site-a/ssh" # sessions: protocol user@host credential description
python3 "$SKILL_DIR/scripts/crt_session.py" put "lab/site-a/ssh" \
 "vm1-192.0.2.11=192.0.2.11=ubuntu-vm1 eth1 - FW-A xe-0/1/2" \
 "vm2-192.0.2.12=192.0.2.12" --user root
```

The terminal tool does not allow shell variables: write the full script path in each call.

## Steps

1. `list <folder>` once. It confirms the folder, shows the names in use, and shows which
   session to copy.
1. `put <folder> NAME[=HOST[=DESCRIPTION]]... [--user U] [--credential C] [--template T]`.
   Give all sessions in one call.
1. Report the session names, the folder, and the two notes in "Tell the user".

## What `put` does

- **Folder**: matched loosely. Punctuation and spaces are ignored and each part can be a
  fragment, so `lab/site-a/ssh` finds `1. example-lab/site-a/ssh`. If it
  matches 0 or more than 1 folder, the script stops and lists them: ask the user or give a
  longer path.
- **New session** (no `NAME.ini`): needs `NAME=HOST`. It is a copy of `--template` (a name
  in the folder, or `folder/name` under `Sessions`), else of the first session in the
  folder. So protocol, port, fonts and logging are those of the folder. The saved password
  and the description of the template are cleared. If `--user` differs from the template's
  user and no `--credential` is given, the credential is cleared too.
- **Existing session**: only the given fields change (`NAME=HOST`, `NAME==DESCRIPTION` for
  the description alone, `--user`, `--credential`). `--credential ""` clears it.
- New names are added to the folder's `__FolderData__.ini`.

## Rules

- **Names**: follow the folder. Seen: `<role>-<rack>` for a device with a DNS name,
  `<name>-<ip>` for a host with an IP, `-console` suffix for a console session.
- **Template**: pick a session of the same protocol and the same access path (SSH to SSH,
  console to console). Prefer one in the same folder.
- **Passwords**: never write a password into a session or a credential file. SecureCRT
  encrypts them with the config passphrase. Use `--credential <title>` when a saved
  credential fits (the script lists the titles when the title is wrong). Else leave it
  empty: SecureCRT asks on the first connect.
- **Not supported**: a new folder, port or protocol changes, deleting or renaming. Ask the
  user to make the folder in SecureCRT first, or copy from a template that has the port.
- The config path comes from `defaults read com.vandyke.SecureCRT "Config Path"` (macOS).
  Set `SECURECRT_CONFIG` to override it.

## Tell the user

- SecureCRT reads the session files at start: restart it to see new sessions.
- If no credential is set, the password is asked on the first connect.

## Check

`python3 "$SKILL_DIR/scripts/crt_session.py" test` runs the self-check on a temporary config
and prints `ok`. Run it after any change to the script.
