import { useState } from 'react'
import MainMenuScreen from './components/MainMenuScreen'
import GameScreen from './components/GameScreen'
import HowToPlayScreen from './components/HowToPlayScreen'
import SpaceMenuBackground from './components/SpaceMenuBackground'
import './App.css'

const API_URL = 'http://localhost:3001/api/comando'

const comandosAyuda = [
  'estado_juego.',
  'acciones_disponibles.',
  'tomar(Artefacto).',
  'usar(Artefacto).',
  'mover(Modulo).',
  'reparar(Sistema).',
  'rescatar(Tripulante).',
  'puedo_ir(Modulo).',
  'donde_esta(Artefacto).',
  'que_tengo.',
  'modulos_visitados.',
  'ruta(Inicio, Fin, Camino).',
  'como_gano.',
  'verifica_gane.',
  'reiniciar_juego.'
]

function App() {
  const [pantalla, setPantalla] = useState('menu')
  const [comando, setComando] = useState('')
  const [cargando, setCargando] = useState(false)
  const [victoria, setVictoria] = useState(false)

  const [consola, setConsola] = useState([
    '[SISTEMA] Operación Atlas inicializada.',
    '[SISTEMA] Esperando conexión con Estación Aurora...',
    '[TERMINAL] Seleccione INICIAR JUEGO para abrir la terminal.'
  ])

  function esperar(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms))
  }

  function limpiarPuntoFinal(texto) {
    const limpio = texto.trim()

    if (limpio.endsWith('.')) {
      return limpio.slice(0, -1)
    }

    return limpio
  }

  function limitarLineas(lineas) {
    const maximoLineas = 18

    if (lineas.length > maximoLineas) {
      return lineas.slice(lineas.length - maximoLineas)
    }

    return lineas
  }

  function agregarLinea(linea) {
    setConsola((anterior) => limitarLineas([...anterior, linea]))
  }

  function convertirComando(texto) {
    const limpio = limpiarPuntoFinal(texto)

    const comandosSinParametro = [
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
    ]

    if (comandosSinParametro.includes(limpio)) {
      return { accion: limpio }
    }

    const comandoRutaTres = limpio.match(
      /^ruta\(([a-zA-Z0-9_]+),\s*([a-zA-Z0-9_]+),\s*([a-zA-Z0-9_]+)\)$/
    )

    if (comandoRutaTres) {
      return {
        accion: 'ruta',
        inicio: comandoRutaTres[1],
        fin: comandoRutaTres[2]
      }
    }

    const comandoRutaDos = limpio.match(
      /^ruta\(([a-zA-Z0-9_]+),\s*([a-zA-Z0-9_]+)\)$/
    )

    if (comandoRutaDos) {
      return {
        accion: 'ruta',
        inicio: comandoRutaDos[1],
        fin: comandoRutaDos[2]
      }
    }

    const comandoUnParametro = limpio.match(/^([a-z_]+)\(([a-zA-Z0-9_]+)\)$/)

    if (comandoUnParametro) {
      return {
        accion: comandoUnParametro[1],
        valor: comandoUnParametro[2]
      }
    }

    return null
  }

  async function llamarBackend(datos) {
    setCargando(true)

    try {
      const respuesta = await fetch(API_URL, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(datos)
      })

      const resultado = await respuesta.json()

      if (resultado.error) {
        return '[ERROR] ' + resultado.error
      }

      return resultado.respuesta || '[SISTEMA] Comando ejecutado.'
    } catch (error) {
      return '[ERROR] No se pudo conectar con el backend. Verifique que Node.js y Prolog estén activos.'
    } finally {
      setCargando(false)
    }
  }

  async function escribirRespuestaProgresiva(texto) {
    const lineas = texto.split('\n')

    for (const linea of lineas) {
      setConsola((anterior) => limitarLineas([...anterior, '']))

      let acumulado = ''

      for (let i = 0; i < linea.length; i++) {
        acumulado += linea[i]

        setConsola((anterior) => {
          const copia = [...anterior]
          copia[copia.length - 1] = acumulado
          return limitarLineas(copia)
        })

        await esperar(8)
      }

      await esperar(70)
    }
  }

  async function ejecutarComando(textoComando = comando) {
    if (cargando) {
      return
    }

    const texto = textoComando.trim()

    if (texto === '') {
      return
    }

    const datos = convertirComando(texto)

    if (!datos) {
      agregarLinea('atlas@aurora:~$ ' + texto)
      await escribirRespuestaProgresiva('[ERROR] Formato de comando no reconocido.')
      setComando('')
      return
    }

    agregarLinea('atlas@aurora:~$ ' + texto)
    setComando('')

    const respuesta = await llamarBackend(datos)

    await escribirRespuestaProgresiva(respuesta)

    if (respuesta.includes('CONDICION DE VICTORIA ALCANZADA')) {
      setVictoria(true)
    }

    if (datos.accion === 'reiniciar_juego') {
      setVictoria(false)
    }
  }

  function manejarEnter(evento) {
    if (evento.key === 'Enter') {
      ejecutarComando()
    }
  }

  async function iniciarJuego() {
    setPantalla('juego')
    setVictoria(false)
    setComando('')
    setConsola([])

    await esperar(150)

    await escribirRespuestaProgresiva('[SISTEMA] Conexión establecida con Estación Aurora.')
    await escribirRespuestaProgresiva('[CAL] Tormenta solar detectada. Sistemas internos inestables.')
    await escribirRespuestaProgresiva(
      '[MISIÓN] Repare los sistemas críticos, rescate a la tripulación y restaure el control de la estación.'
    )
    await escribirRespuestaProgresiva(
      '[TERMINAL] Escriba acciones_disponibles. para iniciar diagnóstico.'
    )
  }

  function mostrarComoJugar() {
    setPantalla('como-jugar')
  }

  function volverMenu() {
    setVictoria(false)
    setPantalla('menu')
  }

  function abrirRepositorio() {
    window.open('https://github.com/Xuri-main/Tec-OperacionAtlas-WebApp', '_blank')
  }

  if (pantalla === 'menu') {
    return (
      <MainMenuScreen
        onStart={iniciarJuego}
        onHowToPlay={mostrarComoJugar}
        onRepository={abrirRepositorio}
      />
    )
  }

  if (pantalla === 'como-jugar') {
    return (
      <HowToPlayScreen
        onBack={volverMenu}
        onStart={iniciarJuego}
      />
    )
  }

  return (
    <main className="atlas-game-page">
      <SpaceMenuBackground />

      <GameScreen
        consola={consola}
        comando={comando}
        setComando={setComando}
        ejecutarComando={ejecutarComando}
        manejarEnter={manejarEnter}
        cargando={cargando}
        volverMenu={volverMenu}
        victoria={victoria}
      />
    </main>
  )
}

export default App