$(document).ready(function() {
    "user strict";

    function refreshCard(holecard, dom_card) {
        $(dom_card).removeClass("spades clubs hearts diamonds");
        if (holecard) {
            $(dom_card).addClass(holecard.suit);
            $(dom_card).text(holecard.rank);
        } else {
            $(dom_card).text('');
        }
    }

    function addPlayer(player) {

        var template = $('#player-template').clone();

        template.attr('id', 'player'+player.id);

        template.find('.name').text(player.name);
        template.find('.stack').text(player.stack);

        var dom_status = template.find('.status');
        dom_status.removeClass('label-danger label-success label-default');
        if(player.status === 'active') {
            dom_status.addClass('label-success');
            dom_status.text('Bet: '+player.bet+' €');
        } else if(player.status === 'folded') {
            dom_status.addClass('label-danger');
            dom_status.text('Folded');
        } else if(player.status === 'out') {
            dom_status.addClass('label-default');
            dom_status.text('Out');
        } else {
            dom_status.text('');
        }

        template.find('.hole-cards div').each(function(index, dom_card) {
            refreshCard(player.hole_cards[index], dom_card);
        });

        return template;
    }

    function render(index) {
        var event = window.pokerEvents[index];

        $("#pot-amount").text(event.pot);
        $('#community-cards div.card').each(function (index, dom_card) {
            refreshCard(event.community_cards[index], dom_card);
        });
        $('#playerContainer').empty();
        event.players.forEach(function (player) {
            $('#playerContainer').append(addPlayer(player));
        });

        $('#player'+event['dealer']).addClass('dealer');
        $('#player'+event['on_turn']).addClass('on-turn');

        $('#message').text(event.message);
    }

    var currentIndex = 0;

    render(currentIndex);

    (function setUpListeners() {
        function next() { if(currentIndex < window.pokerEvents.length - 1) { render(++currentIndex); } else { stopPlay(); } }
        function back() { if(currentIndex > 0) { render(--currentIndex); } }
        function beginning() { render(currentIndex = 0); }
        function end() { render(currentIndex = window.pokerEvents.length - 1); }

        var timerHandle = false;

        function startPlay() {
            timerHandle = setInterval(next, 1200);
            $('#play-button').text('Stop');
        }

        function stopPlay() {
            clearInterval(timerHandle);
            timerHandle = false;
            $('#play-button').text('Play');
        }

        function togglePlay() {
            if(!timerHandle) {
                startPlay();
            } else {
                stopPlay();
            }
        }

        $('#next-button').click(next);
        $('#back-button').click(back);
        $('#beginning-button').click(beginning);
        $('#end-button').click(end);
        $('#play-button').click(togglePlay);

        $(window).keydown(function(e) {
            switch(e.keyCode) {
                case 37:
                    back();
                    break;
                case 39:
                    next();
                    break;
                case 36:
                    beginning();
                    break;
                case 35:
                    end();
                    break;
                case 32:
                    togglePlay()
                    break;
            }
        });
    })();
});
