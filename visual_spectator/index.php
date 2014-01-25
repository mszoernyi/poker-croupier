<!DOCTYPE html>
<html>
    <head>
        <meta charset=utf-8 />
        <title></title>
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" media="screen" href="css/master.css" />
    </head>
    <body>
        <div class="container">
            <?php
            $filesNames = array();
            $directoryIterator = new DirectoryIterator(realpath(__DIR__ . '/../log'));

            foreach ($directoryIterator as $fileInfo) {
                if ($fileInfo->isDot() || $fileInfo->getExtension() !== 'json') {
                    continue;
                }
                $filesNames[] = $fileInfo->getBasename('.' . $fileInfo->getExtension());
            }

            rsort($filesNames);

            foreach ($filesNames as $fileName) {
                echo '<h3><a href="game.php?file=', $fileName, '">', $fileName, '</a></h3>';
            }
            ?>
        </div>
    </body>
</html>