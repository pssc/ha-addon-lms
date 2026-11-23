#!/usr/bin/with-contenv bashio
# Print environment names for debugging without exposing credentials in logs.

if [ "${debug:-false}" = "true" ]; then
    while IFS= read -r -d '' entry; do
        name=${entry%%=*}
        case "${name}" in
            DEBIAN_FRONTEND|HAA_NAME|HA_USER|HOSTNAME|LANG|LMS_ACFG|LMS_CACHE|LMS_CFG|LMS_GROUP|LMS_HACFGDIR|LMS_LOGDIR|LMS_OCFG|LMS_PLUGS|LMS_PREFS|LMS_USER|TZ)
                printf '%s=%s\n' "${name}" "${entry#*=}"
                ;;
            *)
                printf '%s=[redacted]\n' "${name}"
                ;;
        esac
    done < <(env -0)
fi
