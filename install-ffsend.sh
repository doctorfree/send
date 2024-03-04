#!/usr/bin/env bash
#
platform=$(uname -s)
if [ "${platform}" == "Darwin" ]; then
  suff="macos"
else
  suff="linux-x64-static"
fi

# GH_TOKEN, a GitHub token must be set in the environment
# If it is not already set then the convenience build script will set it
if [ "${GH_TOKEN}" ]; then
  export GH_TOKEN="${GH_TOKEN}"
else
  export GH_TOKEN="__GITHUB_API_TOKEN__"
fi
# Check to make sure
echo "${GH_TOKEN}" | grep __GITHUB_API | grep __TOKEN__ > /dev/null && {
  # It didn't get set right, unset it
  export GH_TOKEN=
}

if [ "${GH_TOKEN}" ]; then
  AUTH_HEADER="-H \"Authorization: Bearer ${GH_TOKEN}\""
else
  AUTH_HEADER=
fi

API_URL="https://api.github.com/repos/timvisee/ffsend/releases/latest"
DL_URL=
DL_URL=$(curl --silent ${AUTH_HEADER} "${API_URL}" \
    | jq --raw-output '.assets | .[]?.browser_download_url' \
    | grep "${suff}")

[ "${DL_URL}" ] && {
  printf "\n\tInstalling ffsend ..."
  wget --quiet -O "/tmp/ffsend$$" "${DL_URL}"
  [ -f /tmp/ffsend$$ ] && {
    [ -d /usr/local/bin ] || sudo mkdir -p /usr/local/bin
    sudo cp /tmp/ffsend$$ /usr/local/bin/ffsend
    sudo chmod 755 /usr/local/bin/ffsend
    /usr/local/bin/ffsend debug | grep infer-command > /dev/null && {
      for cmd in ffput ffget ffdel
      do
        sudo rm -f /usr/local/bin/${cmd}
        sudo ln -s /usr/local/bin/ffsend /usr/local/bin/${cmd}
      done
    }
  }
  rm -f "/tmp/ffsend$$"
  printf " done\n"
}
