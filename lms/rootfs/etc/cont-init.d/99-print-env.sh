#!/usr/bin/with-contenv bashio
# Print the environment for debugging while hiding credentials in logs.

if [ "${debug:-false}" = "true" ]; then
    while IFS= read -r -d '' entry; do
        name=${entry%%=*}
        case "${name^^}" in
            *TOKEN*|*PASS*|*SECRET*|*KEY*|*CREDENTIAL*|*AUTH*|*COOKIE*)
                printf '%s=[redacted]\n' "${name}"
                ;;
            *)
                printf '%s=%s\n' "${name}" "${entry#*=}"
                ;;
        esac
    done < <(env -0)
fi
