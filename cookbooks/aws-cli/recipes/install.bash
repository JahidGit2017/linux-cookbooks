#!/bin/bash -e

function install()
{
    # Clean Up

    initializeFolder "${AWS_CLI_INSTALL_FOLDER}"

    # Install

    local -r tempFolder="$(getTemporaryFolder)"

    unzipRemoteFile "${AWS_CLI_DOWNLOAD_URL}" "${tempFolder}"
    "${tempFolder}/awscli-bundle/install" -b '/usr/local/bin/aws' -i "${AWS_CLI_INSTALL_FOLDER}"
    rm -f -r "${tempFolder}"

    # Config Profile

    local -r profileConfigData=('__INSTALL_FOLDER__' "${AWS_CLI_INSTALL_FOLDER}")

    createFileFromTemplate "${appPath}/../templates/aws-cli.sh.profile" '/etc/profile.d/aws-cli.sh' "${profileConfigData[@]}"

    # Display Version

    info "\n$("${AWS_CLI_INSTALL_FOLDER}/bin/aws" --version 2>&1)"
}

function main()
{
    local -r appPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # shellcheck source=/dev/null
    source "${appPath}/../../../libraries/util.bash"
    # shellcheck source=/dev/null
    source "${appPath}/../attributes/default.bash"

    checkRequireSystem
    checkRequireRootUser

    header 'INSTALLING AWS-CLI'

    install
    installCleanUp
}

main "${@}"