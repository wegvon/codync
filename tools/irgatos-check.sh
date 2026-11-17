#!/bin/sh
# Checks that the Irgatos fork's changes survived an upstream merge (IRGATOS.md lists them).
set -u
cd "$(dirname "$0")/.."
fail=0
need() { grep -q -- "$2" "$1" || { echo "missing in $1: $2"; fail=1; }; }
need apps/project.yml "CODYNC_APP_NAME: Irgatos"
need apps/project.yml "CODYNC_IOS_BUNDLE_ID: com.wegvon.irgatos.ios"
need apps/project.yml "CODYNC_URL_SCHEME: irgatos"
need apps/project.yml 'CODYNC_POSTHOG_KEY: "off"'
need apps/project.yml "CODYNC_PUSH_RELAY_URL:"
need apps/ios/Resources/Info.plist "CodyncPostHogKey"
need apps/ios/Resources/Info.plist "CodyncPushRelayURL"
need apps/ios/Kit/Sources/CodyncKit/Client/AppEnvironment.swift 'info("CodyncURLScheme")'
need apps/ios/Kit/Sources/CodyncKit/Analytics/Analytics.swift 'info("CodyncPostHogKey")'
need apps/ios/Kit/Sources/CodyncKit/Client/SharedStore.swift 'info("CodyncPushRelayURL")'
need apps/ios/Kit/Sources/CodyncKit/L10n.swift "func branded"
need apps/ios/App/Push.swift "SharedStore.relayURL.isEmpty"
for f in apps/shared/Config/main.plist apps/shared/Config/dev.plist; do
  grep -q "pk_live\|pk_test\|codync.dev" "$f" && { echo "$f still points at Codync Cloud"; fail=1; }
done
[ "$fail" = 0 ] && echo "Irgatos fork: all changes in place."
exit "$fail"
