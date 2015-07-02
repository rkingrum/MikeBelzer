$(document).ready(function() {
    /* FULLPAGE STUFF */
    $('#fullpage').fullpage({
        sectionSelector: 'section',

        onLeave: function(index, nextIndex, direction) {
            var navButtons = $('#footer').find('> div');

            $(navButtons[index-1]).removeClass('selected');
            $(navButtons[nextIndex-1]).addClass('selected');

            console.log(nextIndex);
            if (nextIndex == 2) {
                $('#header').animate({'background-color': 'rgba(200, 200, 200, .3)', color: '#0e000e'}, 500);
                $('#footer').animate({'background-color': 'rgba(200, 200, 200, .3)', color: '#0e000e'}, 500);
            } else if (index == 2) {
                $('#header').animate({'background-color': 'rgba(0, 0, 0, .8)', color: '#e1eee1'}, 500);
                $('#footer').animate({'background-color': 'rgba(0, 0, 0, .8)', color: '#e1eee1'}, 500);
            }
        }
    });
    /* END FULLPAGE STUFF */

    /* IMAGE SCROLLING */
    var scrollInterval = null;

    function imageScrollUp() {

    }

    function imageScrollDown() {

    }

    var photoSection = $('#photos');
    photoSection.find('.arrow-up').hover(
        imageScrollUp,
        function() {
            clearInterval(scrollInterval);
        }
    );
    photoSection.find('.arrow-up').hover(
        imageScrollDown,
        function() {
            clearInterval(scrollInterval);
        }
    );
    /* END IMAGE SCROLLING */
});