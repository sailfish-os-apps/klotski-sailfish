import QtQuick 2.0
import Sailfish.Silica 1.0
import "components"
import "pages"
import "cover"

ApplicationWindow {
    cover: Component {
        CoverPage { }
    }
    initialPage: Component {
        FirstPage { }
    }

    property KlotskiPlayground currentPlayground : null;
}


