function showModal(contentHtml) {
    let overlay = $('#modal-overlay');
    let content = overlay.find('#modal-content');

    content.html(contentHtml);
    overlay.addClass('active');
}

$(document).on('ready turbolinks:load', function() {
    let folders = $('.folder');

    folders.find('> .title').on('click', function(e) {
        let folder = $(e.target).parent('.folder');

        folder.toggleClass('expanded');
    });

    $.each(folders, function (_index, folder) {
        folder = $(folder);
        let backgroundImage = folder.find('.image:first-of-type > img').attr('src');

        folder.find('.preview').css('background-image', "url('" + backgroundImage + "')");
    });

    $('.folder .image').on('click', function(e) {
        let target = $(e.target);
        if (!target.hasClass('image')) {
            target = target.parent('.image');
        }

        let img    = target.find('img');
        let imgSrc = img.attr('src');
        let alt    = img.attr('alt');

        let modalContent = "<div class='image-modal' style=\"background-image: url('" + imgSrc + "');\"></div>";
            // "<img class='image-modal' src='" + imgSrc + "' alt='" + alt + "' />";

        showModal(modalContent);
    });

    let modalOverlay = $('#modal-overlay');
    modalOverlay.on('click', function(e) {
        if (e.target.id != 'modal-overlay') { return; }

        $(e.target).removeClass('active');
    });
});