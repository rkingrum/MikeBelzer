function Carousal(target) {
    this.target       = $(target);
    this.currentIndex = 0;
    this.imageCount   = this.target.find('.image').length;
    this.halfLength   = Math.round(this.imageCount / 2);
    this.interval     = 3000; // in ms
    this.timeoutId    = null;

    let controls = this.target.find('.controls');
    controls.find('.previous').on('click', this.triggerPrevious.bind(this));
    controls.find('.next').on('click', this.triggerNext.bind(this));
    controls.find('.image-shortcut').on('click', this.triggerShortcut.bind(this))
}
Carousal.prototype.next = function() {
    this.target.find('.image-' + this.nextIndex())
        .stop()
        .css({
            display: 'block',
            right: '-100%',
            left: '100%'
        })
        .animate({
            right: '0',
            left: '0'
        }, 250);

    this.target.find('.image-' + this.currentIndex)
        .stop()
        .animate({
            left: '-100%',
            right: '100%'
        }, 250, function() {
            $(this).css({ display: 'none' })
        });

    this.currentIndex = this.nextIndex();

    this.target.find('.controls .image-shortcuts .image-shortcut').removeClass('selected');
    this.target.find('.controls .image-shortcuts .image-shortcut[data-image-index=' + this.currentIndex + ']').addClass('selected');

    this.timeoutId = setTimeout(this.next.bind(this), this.interval);
};
Carousal.prototype.previous = function() {
    this.target.find('.image-' + this.previousIndex())
        .stop()
        .css({
            display: 'block',
            left: '-100%',
            right: '100%'
        })
        .animate({
            right: '0',
            left: '0'
        }, 250);

    this.target.find('.image-' + this.currentIndex)
        .stop()
        .animate({
            right: '-100%',
            left: '100%'
        }, 250, function() {
            $(this).css({ display: 'none' })
        });

    this.currentIndex = this.previousIndex();

    this.target.find('.controls .image-shortcuts .image-shortcut').removeClass('selected');
    this.target.find('.controls .image-shortcuts .image-shortcut[data-image-index=' + this.currentIndex + ']').addClass('selected');

    this.timeoutId = setTimeout(this.next.bind(this), this.interval);
};
Carousal.prototype.start = function() {
    this.timeoutId = setTimeout(this.next.bind(this), this.interval);
};
Carousal.prototype.nextIndex = function() {
    let nextIndex = this.currentIndex + 1;

    if (nextIndex >= this.imageCount) {
        nextIndex = 0;
    }

    return nextIndex
};
Carousal.prototype.previousIndex = function() {
    let previousIndex = this.currentIndex - 1;

    if (previousIndex < 0) {
        previousIndex = this.imageCount - 1;
    }

    return previousIndex
};
Carousal.prototype.triggerPrevious = function() {
    clearTimeout(this.timeoutId);
    this.previous();
};
Carousal.prototype.triggerNext = function() {
    clearTimeout(this.timeoutId);
    this.next();
};
// TODO: This whole function needs to be refactored
// Also this is horrific
Carousal.prototype.triggerShortcut = function(e) {
    clearTimeout(this.timeoutId);

    let shortcutIndex = $(e.target).data('image-index');
    let distance = Math.abs(shortcutIndex - this.currentIndex);

    if (distance == 0) { return }

    // Direction indicates whether to rotate right (1) or left (-1).
    let direction = shortcutIndex > this.currentIndex ? 1 : -1;
    if (distance > this.halfLength) {
        direction *= -1;
    }

    let finished = false;
    let count = 1;
    for (let x = this.currentIndex + direction; !finished; x += direction, count++) {
        if (direction == 1 && x >= this.imageCount) {
            x = 0;
        } else if (direction == -1 && x < 0) {
            x = this.imageCount - 1;
        }

        let directedOffset = direction * count * 100;
        this.target.find('.image-' + x).css({
            display: 'block',
            right: -directedOffset + '%',
            left: directedOffset + '%',
            'z-index': count
        });

        if (x == shortcutIndex) { finished = true }
    }

    count -= 1;
    finished = false;
    for (let x = this.currentIndex; !finished; x += direction, count--) {
        if (direction == 1 && x >= this.imageCount) {
            x = 0;
        } else if (direction == -1 && x < 0) {
            x = this.imageCount - 1;
        }

        let props = null;
        let func = null;
        if (x == shortcutIndex) {
            props = {
                right: '0',
                left: '0'
            };

            finished = true;
        } else {
            let directedOffset = 100 * count * direction;
            props = {
                right: directedOffset + '%',
                left: -directedOffset + '%'
            };

            func = function() {
                $(this).css({ display: 'none' });
            };
        }

        this.target.find('.image-' + x).stop().animate(props, 500, func);
    }

    this.currentIndex = shortcutIndex;

    this.target.find('.controls .image-shortcuts .image-shortcut').removeClass('selected');
    this.target.find('.controls .image-shortcuts .image-shortcut[data-image-index=' + this.currentIndex + ']').addClass('selected');

    this.timeoutId = setTimeout(this.next.bind(this), this.interval + 500);
};

$(document).on('ready turbolinks:load', function() {
    $.each($('.carousal'), function(index, target) {
        new Carousal(target).start();
    });
});
