#!/bin/bash -e

function installDependencies()
{
    runAptGetUpgrade
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

    header 'INSTALLING ESSENTIAL PACKAGES'

    installDependencies
    installAptGetPackages "${ESSENTIAL_PACKAGES[@]}"
    installCleanUp
}

main "${@}"