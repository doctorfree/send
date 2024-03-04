# Send

## Contents

- [Send server](#send)
- [Command line ffsend](#ffsend)
- [References](#references)
- [Notes](#notes)
- Files
  - [docker-compose.yml](docker-compose.yml)
  - [install_ffsend.sh](install_ffsend.sh)
  - [example-script.sh](example-script.sh)
  - [start](start)
  - [stop](stop)
  - [upgrade](upgrade)

## Send

Self-host a `Send` service:

```bash
git clone https://github.com/doctorfree/send
cd send
vi docker-compose.yml
./start
```

See the [Send repository README](https://github.com/timvisee/send#readme)
for information and documentation on `Send` and the
[Send docker compose README](https://github.com/timvisee/send-docker-compose#readme)
for information and documentation on deploying `Send` with `docker compose`.

## ffsend

> Easily and securely share files from the command line.
> A [Send](https://github.com/timvisee/send) client.

Easily and securely share files and directories from the command line through a
safe, private and encrypted link using a single simple command.
Files are shared using the [Send](https://github.com/timvisee/send) service and may be up
to 1GB. Others are able to download these files with this tool, or through
their web browser.

All files are always encrypted on the client, and secrets are never shared with
the remote host. An optional password may be specified, and a default file
lifetime of 1 (up to 20) download or 24 hours is enforced to ensure your stuff
does not remain online forever.
This provides a secure platform to share your files.

The public [Send](https://github.com/timvisee/send) service that is used as default host is provided by
[@timvisee][timvisee] ([info](https://gitlab.com/timvisee/ffsend/-/issues/111)).  
To use a self-hosted `send` service, set the `FFSEND_HOST` environment variable
to the desired host or specify the host on the command line with `--host <URL>`.

### Install ffsend

As a normal user with `sudo` privilege run the following:

```bash
git clone https://github.com/doctorfree/send
cd send
./install-ffsend.sh
# Installs in /usr/local/bin
/usr/local/bin/ffsend debug
```

### ffsend configuration and environment

The following environment variables may be used to configure the following
defaults. The CLI flag is shown along with it, to better describe the relation
to command line arguments:

| Variable                  | CLI flag                       | Description                                   |
| :------------------------ | :----------------------------: | :-------------------------------------------- |
| `FFSEND_HISTORY`          | `--history <FILE>`             | History file path                             |
| `FFSEND_HOST`             | `--host <URL>`                 | Upload host                                   |
| `FFSEND_TIMEOUT`          | `--timeout <SECONDS>`          | Request timeout (0 to disable)                |
| `FFSEND_TRANSFER_TIMEOUT` | `--transfer-timeout <SECONDS>` | Transfer timeout (0 to disable)               |
| `FFSEND_EXPIRY_TIME`      | `--expiry-time <SECONDS>`      | Default upload expiry time                    |
| `FFSEND_DOWNLOAD_LIMIT`   | `--download-limit <DOWNLOADS>` | Default download limit                        |
| `FFSEND_API`              | `--api <VERSION>`              | Server API version, `-` to lookup             |
| `FFSEND_BASIC_AUTH`       | `--basic-auth <USER:PASSWORD>` | Basic HTTP authentication credentials to use. |

These environment variables may be used to toggle a flag, simply by making them
available. The actual value of these variables is ignored, and variables may be
empty.

| Variable             | CLI flag        | Description                        |
| :------------------- | :-------------: | :--------------------------------- |
| `FFSEND_FORCE`       | `--force`       | Force operations                   |
| `FFSEND_NO_INTERACT` | `--no-interact` | No interaction for prompts         |
| `FFSEND_YES`         | `--yes`         | Assume yes for prompts             |
| `FFSEND_INCOGNITO`   | `--incognito`   | Incognito mode, don't use history  |
| `FFSEND_OPEN`        | `--open`        | Open share link of uploaded file   |
| `FFSEND_ARCHIVE`     | `--archive`     | Archive files uploaded             |
| `FFSEND_EXTRACT`     | `--extract`     | Extract files downloaded           |
| `FFSEND_COPY`        | `--copy`        | Copy share link to clipboard       |
| `FFSEND_COPY_CMD`    | `--copy-cmd`    | Copy download command to clipboard |
| `FFSEND_QUIET`       | `--quiet`       | Log quiet information              |
| `FFSEND_VERBOSE`     | `--verbose`     | Log verbose information            |

Some environment variables may be set at compile time to tweak some defaults.

| Variable     | Description                                                                |
| :----------- | :------------------------------------------------------------------------- |
| `XCLIP_PATH` | Set fixed `xclip` binary path when using `clipboard-bin` (Linux, &ast;BSD) |
| `XSEL_PATH`  | Set fixed `xsel` binary path when using `clipboard-bin` (Linux, &ast;BSD)  |

At this time, no configuration or _dotfile_ file support is available.

### ffsend binary for subcommands: `ffput`, `ffget`, `ffdel`

`ffsend` supports having a separate binaries for single subcommands, such as
having `ffput` and `ffget` just for to upload and download using `ffsend`.
This allows simple and direct commands like:
```bash
ffput my-file.txt
ffget https://send.vis.ee/#sample-share-url
```

This works for a predefined list of binary names:

- `ffput` → `ffsend upload ...`
- `ffget` → `ffsend download ...`
- `ffdel` → `ffsend delete ...`

### ffsend scriptability

`ffsend` is optimized for use in automated scripts. It provides some specialized
arguments to control `ffsend` without user interaction.

- `--no-interact` (`-I`): do not allow user interaction. For prompts not having
    a default value, the application will quit with an error, unless `--yes`
    or `--force` is provided.
    This should **always** be given when using automated scripting.  
    Example: when uploading a directory, providing this flag will stop the
    archive question prompt form popping up, and will archive the directory as
    default option.
- `--yes` (`-y`): assume the yes option for yes/no prompt by default.  
    Example: when downloading a file that already exists, providing this flag
    will assume yes when asking to overwrite a file.
- `--force` (`-f`): force to continue with the action, skips any warnings that
    would otherwise quit the application.  
    Example: when uploading a file that is too big, providing this flag will
    ignore the file size warning and forcefully continues.
- `--quiet` (`-q`): be quiet, print as little information as possible.  
    Example: when uploading a file, providing this flag will only output the
    final share URL.

Generally speaking, use the following rules when automating:
- Always provide `--no-interact` (`-I`).
- Provide any combination of `--yes` (`-y`) and `--force` (`-f`) for actions you
  want to complete no matter what.
- When passing share URLs along, provide the `--quiet` (`-q`) flag, when
  uploading for example.

These flags can also automatically be set by defining environment variables as
specified here:  
[» Configuration and environment](#configuration-and-environment)

## References

- https://github.com/timvisee/send
- https://github.com/timvisee/send/blob/master/docs/docker.md
- https://github.com/timvisee/send-docker-compose

## Notes

After spawning the container, you may have to adjust the bind volume mount permissions again.

If you want to force darkmode, please read [here](https://github.com/timvisee/send/issues/174#issuecomment-1802243265).
