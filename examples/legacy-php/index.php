<?php
// A deliberately plain PHP page: no framework, no composer, no build step.
$messages = ['Lift', 'and', 'shift'];
?>
<!doctype html>
<html lang="en">
<head><meta charset="utf-8"><title>Legacy PHP on Elastic Beanstalk</title></head>
<body>
  <h1><?= htmlspecialchars(implode(' ', $messages)) ?></h1>
  <p>PHP version: <strong><?= PHP_VERSION ?></strong></p>
  <p>Web server: <?= htmlspecialchars($_SERVER['SERVER_SOFTWARE'] ?? 'unknown') ?></p>
  <p>Host: <?= htmlspecialchars(gethostname()) ?></p>
</body>
</html>
