<!DOCTYPE html>
<html>
<head>
    <meta charset=utf-8 />
    <title></title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" media="screen" href="css/master.css" />

    <script src="js/lib/jquery/jquery-2.0.3.js"></script>
    <script>window.pokerEvents = <?php readfile("../log/{$_GET['file']}.json"); ?></script>
    <script src="js/lib/main.js"></script>
</head>
<body>
<div class="container game-container">
    <div class="panel panel-body pokertable">
        <div id="community-cards">
            <div id="flop" class="clearfix">
                <div class="card"></div>
                <div class="card"></div>
                <div class="card"></div>
            </div>
            <div id="turn">
                <div class="card"></div>
            </div>
            <div id="river">
                <div class="card"></div>
            </div>
        </div>
        <div id="pot">
            <span class="label label-success">Pot: <span id="pot-amount"></span> €</span>
        </div>
        <div id="controls">
            <a id="beginning-button">Beginning</a>
            <a id="back-button">Back</a>
            <a id="play-button">Play</a>
            <a id="next-button">Next</a>
            <a id="end-button">End</a>
        </div>
    </div>

    <div id="playerContainer">
    </div>

    <div class="alert alert-info clearfix message-container">
        <h4 id="message"></h4>
    </div>
</div>

<div id="templates">
    <div class="panel panel-default player-panel" id="player-template">
        <div class="panel-heading">
            <h3 class="panel-title"><span class="name"></span><br/>
                <span class="label label-default"><span class="stack"></span> €</span></h3>
        </div>
        <div class="panel-body hole-cards">
            <div class="card"></div>
            <div class="card"></div>
        </div>
        <div class="panel-footer">Current status:<br/><span class="label label-success status"></span></div>
    </div>
</div>

</body>
</html>