# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-klotski

CONFIG += sailfishapp

SOURCES += src/harbour-klotski.cpp

OTHER_FILES += qml/harbour-klotski.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    rpm/harbour-klotski.changes.in \
    rpm/harbour-klotski.spec \
    rpm/harbour-klotski.yaml \
    harbour-klotski.desktop \
    qml/components/KlotskiPlayground.qml \
    translations/harbour-klotski.ts \
    harbour-klotski.svg \
    harbour-klotski.png

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS +=

