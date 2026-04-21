<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Software de ventas para gestión de inventario y ventas.">
    <title>AUTORECAUDOS</title>
    
<link rel="stylesheet" type="text/css" href="presentacion/login.css">


<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Software de ventas para gestión de inventario y ventas.">
    <title>AUTORECAUDOS</title>
    
   
</head>
<body>

    <!-- Video de fondo -->
    <video id="background-video" autoplay muted loop>
        <source src="recursos/jaguaress.mp4" type="video/mp4">
        Tu navegador no soporta videos HTML5.
    </video>

    <!-- Formulario de inicio de sesión -->
    <div class="login-container">
        <img src="presentacion/dyd.png" alt="Logo del club" class="logo">
        <h1>Iniciar sesión</h1>
        <form name="formulario" method="post" action="validar.jsp">
            <h2>Usuario</h2>
            <div class="form-group">
                <input type="text" name="identificacion" id="identificacion" required placeholder="Usuario">
            </div>
            <h2>Contraseña</h2>
            <div class="form-group">
                <input type="password" name="clave" id="clave" required placeholder="Contraseña">
            </div>
            <button type="submit" class="btn-custom">Ingresar</button>
        </form>

        <div class="forgot-password">
          <!--<a href="#">¿Olvidaste tu contraseña?</a>-->
        </div>
    </div>

    <script src="recursos/js/jquery.min.js"></script>
    <script src="recursos/js/bootstrap.min.js"></script>

</body>
</html>
