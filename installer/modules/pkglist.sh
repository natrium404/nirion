#!/usr/bin/env bash

module_init() {
    log STEP "Initializing pkglist module"
}

module_validate() {
    [ "${ENABLE_PKGLIST}" = "true" ]
}

module_run() {
    local PKG_DIR="$HOME/.nirion/packages"

    if [ -d "${PKG_DIR}" ]; then
        if [ -f "${PKG_DIR}/pkg" ]; then
            mkdir -p "${HOME}/bin"
            create_symlink "${PKG_DIR}/pkg" "${HOME}/bin"

            SUMMARY_STATUS[pkglist]="Done"
        else
            log WARN "No pkg script in $PKG_DIR folder"
            SUMMARY_STATUS[pkglist]="Skipped"
        fi
    else
        log WARN "No package folder in setup folder"
        SUMMARY_STATUS[pkglist]="Skipped"
    fi
}

module_summary() {
    log INFO "pkglist module status: ${SUMMARY_STATUS[pkglist]}"
}
