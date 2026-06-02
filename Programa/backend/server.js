const http = require('http');
const { spawn } = require('child_process');
const path = require('path');

const PUERTO = 3001;

const rutaProlog = path.join(__dirname, '..', 'prolog');
const archivoMain = path.join(rutaProlog, 'main.pl');
const archivoAdaptador = path.join(rutaProlog, 'adaptador_web.pl');

const prolog = spawn('swipl', [
  '-q',
  '-s', archivoMain,
  '-s', archivoAdaptador,
  '-g', 'iniciar_puente'
], {
  cwd: rutaProlog
});

let respuestaActual = null;
let cola = [];
let lineasRespuesta = [];
let salidaPendiente = '';

prolog.stdout.on('data', (data) => {
  salidaPendiente += data.toString();

  const lineas = salidaPendiente.split(/\r?\n/);
  salidaPendiente = lineas.pop();

  for (const linea of lineas) {
    procesarLineaProlog(linea);
  }
});

prolog.stderr.on('data', (data) => {
  console.error('Error de Prolog:', data.toString());
});

prolog.on('close', (codigo) => {
  console.log('Proceso Prolog finalizado con codigo:', codigo);

  if (respuestaActual) {
    respuestaActual.reject(new Error('El proceso de Prolog se cerro inesperadamente.'));
    respuestaActual = null;
  }

  while (cola.length > 0) {
    const pendiente = cola.shift();
    pendiente.reject(new Error('El proceso de Prolog no esta disponible.'));
  }
});

function procesarLineaProlog(linea) {
  const texto = linea.trimEnd();

  if (texto === 'puente_listo') {
    console.log('Puente con Prolog iniciado correctamente.');
    return;
  }

  if (!respuestaActual) {
    return;
  }

  if (texto === 'fin_respuesta') {
    const respuesta = lineasRespuesta.join('\n').trim();

    respuestaActual.resolve({
      respuesta
    });

    respuestaActual = null;
    lineasRespuesta = [];
    procesarCola();
    return;
  }

  lineasRespuesta.push(texto);
}

function enviarAProlog(comando) {
  return new Promise((resolve, reject) => {
    cola.push({
      comando,
      resolve,
      reject
    });

    procesarCola();
  });
}

function procesarCola() {
  if (respuestaActual !== null) {
    return;
  }

  if (cola.length === 0) {
    return;
  }

  respuestaActual = cola.shift();
  lineasRespuesta = [];

  prolog.stdin.write(respuestaActual.comando + '\n');
}

function leerCuerpo(req) {
  return new Promise((resolve, reject) => {
    let cuerpo = '';

    req.on('data', (parte) => {
      cuerpo += parte.toString();
    });

    req.on('end', () => {
      try {
        const datos = cuerpo ? JSON.parse(cuerpo) : {};
        resolve(datos);
      } catch (error) {
        reject(new Error('El cuerpo de la solicitud no es JSON valido.'));
      }
    });
  });
}

function esAtomoSeguro(valor) {
  return typeof valor === 'string' && /^[a-z][a-zA-Z0-9_]*$/.test(valor);
}

function construirComandoProlog(datos) {
  const accion = datos.accion;

  const accionesSinParametro = [
    'estado_juego',
    'acciones_disponibles',
    'como_gano',
    'verifica_gane',
    'reiniciar_juego',
    'ayuda',
    'donde_estoy',
    'que_tengo',
    'modulos_visitados',
    'descripcion_modulo_actual'
  ];

  const accionesUnParametro = [
    'mover',
    'tomar',
    'usar',
    'reparar',
    'rescatar',
    'donde_esta',
    'puedo_ir'
  ];

  if (accionesSinParametro.includes(accion)) {
    return accion + '.';
  }

  if (accionesUnParametro.includes(accion)) {
    if (!esAtomoSeguro(datos.valor)) {
      throw new Error('El valor enviado no es un atomo Prolog valido.');
    }

    return accion + '(' + datos.valor + ').';
  }

  if (accion === 'ruta') {
    if (!esAtomoSeguro(datos.inicio) || !esAtomoSeguro(datos.fin)) {
      throw new Error('Inicio y fin deben ser atomos Prolog validos.');
    }

    return 'ruta(' + datos.inicio + ',' + datos.fin + ').';
  }

  throw new Error('Accion no permitida.');
}

function enviarJson(res, codigo, datos) {
  res.writeHead(codigo, {
    'Content-Type': 'application/json; charset=utf-8',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type'
  });

  res.end(JSON.stringify(datos));
}

const servidor = http.createServer(async (req, res) => {
  if (req.method === 'OPTIONS') {
    enviarJson(res, 200, {});
    return;
  }

  if (req.method === 'GET' && req.url === '/api/salud') {
    enviarJson(res, 200, {
      estado: 'ok',
      mensaje: 'Backend activo y listo para comunicarse con Prolog.'
    });
    return;
  }

  if (req.method === 'POST' && req.url === '/api/comando') {
    try {
      const datos = await leerCuerpo(req);
      const comando = construirComandoProlog(datos);
      const resultado = await enviarAProlog(comando);

      enviarJson(res, 200, {
        comando,
        respuesta: resultado.respuesta
      });
    } catch (error) {
      enviarJson(res, 400, {
        error: error.message
      });
    }

    return;
  }

  enviarJson(res, 404, {
    error: 'Ruta no encontrada.'
  });
});

servidor.listen(PUERTO, () => {
  console.log('Backend iniciado en http://localhost:' + PUERTO);
});

process.on('SIGINT', () => {
  console.log('Cerrando backend...');
  prolog.kill();
  process.exit();
});