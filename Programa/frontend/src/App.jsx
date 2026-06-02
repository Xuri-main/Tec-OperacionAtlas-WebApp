import { useEffect, useRef, useState } from 'react'
import MainMenuScreen from './components/MainMenuScreen'

const API_URL = 'http://localhost:3001/api/comando'

const comandosAyuda = [
  'estado_juego.',
  'acciones_disponibles.',
  'tomar(Artefacto).',
  'usar(Artefacto).',
  'mover(Modulo).',
  'reparar(Sistema).',
  'rescatar(Tripulante).',
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
  const [consola, setConsola] = useState([
    '[SISTEMA] Operación Atlas inicializada.',
    '[SISTEMA] Esperando conexión con Estación Aurora...',
    '[SISTEMA] Use "Iniciar juego" para abrir la terminal.'
  ])
  const [estadoTexto, setEstadoTexto] = useState('Sin datos de partida.')
  const [loreTexto, setLoreTexto] = useState(
    'La Estación Aurora permanece en silencio tras la tormenta solar. Los módulos internos responden de forma intermitente.'
  )
  const [cargando, setCargando] = useState(false)
  const consolaRef = useRef(null)

  useEffect(() => {
    if (consolaRef.current) {
      consolaRef.current.scrollTop = consolaRef.current.scrollHeight
    }
  }, [consola])

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

  function limpiarPuntoFinal(texto) {
    const limpio = texto.trim()
    if (limpio.endsWith('.')) {
      return limpio.slice(0, -1)
    }
    return limpio
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

    const comandoUnParametro = limpio.match(/^([a-z_]+)\(([a-zA-Z0-9_]+)\)$/)

    if (comandoUnParametro) {
      return {
        accion: comandoUnParametro[1],
        valor: comandoUnParametro[2]
      }
    }

    const comandoRutaTres = limpio.match(/^ruta\(([a-zA-Z0-9_]+),\s*([a-zA-Z0-9_]+),\s*([a-zA-Z0-9_]+)\)$/)

    if (comandoRutaTres) {
      return {
        accion: 'ruta',
        inicio: comandoRutaTres[1],
        fin: comandoRutaTres[2]
      }
    }

    const comandoRutaDos = limpio.match(/^ruta\(([a-zA-Z0-9_]+),\s*([a-zA-Z0-9_]+)\)$/)

    if (comandoRutaDos) {
      return {
        accion: 'ruta',
        inicio: comandoRutaDos[1],
        fin: comandoRutaDos[2]
      }
    }

    return null
  }

  async function ejecutarComando(textoComando = comando) {
    const texto = textoComando.trim()

    if (texto === '') {
      return
    }

    const datos = convertirComando(texto)

    if (!datos) {
      setConsola((anterior) => [
        ...anterior,
        'atlas@aurora:~$ ' + texto,
        '[ERROR] Formato de comando no reconocido.'
      ])
      setComando('')
      return
    }

    setConsola((anterior) => [
      ...anterior,
      'atlas@aurora:~$ ' + texto
    ])

    const respuesta = await llamarBackend(datos)

    setConsola((anterior) => [
      ...anterior,
      respuesta
    ])

    setComando('')

    if (
      datos.accion === 'estado_juego' ||
      datos.accion === 'mover' ||
      datos.accion === 'tomar' ||
      datos.accion === 'usar' ||
      datos.accion === 'reparar' ||
      datos.accion === 'rescatar' ||
      datos.accion === 'reiniciar_juego'
    ) {
      actualizarPanelEstado()
    }
  }

  async function actualizarPanelEstado() {
    const estado = await llamarBackend({ accion: 'estado_juego' })
    setEstadoTexto(estado)

    const descripcion = await llamarBackend({ accion: 'descripcion_modulo_actual' })
    setLoreTexto(descripcion)
  }

  async function iniciarJuego() {
    setPantalla('juego')
    setConsola([
      '[SISTEMA] Conexión establecida con Estación Aurora.',
      '[SISTEMA] Terminal de ingeniería activa.',
      '[SISTEMA] Escriba "acciones_disponibles." para consultar opciones.',
      '[SISTEMA] Escriba "como_gano." para recibir guía lógica.'
    ])

    setTimeout(() => {
      actualizarPanelEstado()
    }, 200)
  }

  async function accionRapida(accion) {
    await ejecutarComando(accion)
  }

  function manejarEnter(evento) {
    if (evento.key === 'Enter') {
      ejecutarComando()
    }
  }

  function mostrarComoJugar() {
    setPantalla('como-jugar')
  }

  function mostrarOpciones() {
    setPantalla('opciones')
  }

  function volverMenu() {
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
      onOptions={mostrarOpciones}
      onRepository={abrirRepositorio}
    />
  )
}

  if (pantalla === 'como-jugar') {
    return (
      <main className="app-shell">
        <FondoEspacial />

        <section className="info-panel">
          <button className="back-button" onClick={volverMenu}>← Volver</button>
          <h2>Cómo jugar</h2>
          <p>
            Operación Atlas se juega escribiendo comandos en la terminal. Cada comando se envía
            al cerebro lógico en Prolog, donde se valida si la acción es posible.
          </p>

          <div className="command-list">
            {comandosAyuda.map((item) => (
              <code key={item}>{item}</code>
            ))}
          </div>

          <p className="hint">
            Consejo: empiece con <code>estado_juego.</code> y luego use <code>acciones_disponibles.</code>
          </p>
        </section>
      </main>
    )
  }

  if (pantalla === 'opciones') {
    return (
      <main className="app-shell">
        <FondoEspacial />

        <section className="info-panel">
          <button className="back-button" onClick={volverMenu}>← Volver</button>
          <h2>Opciones</h2>
          <p>
            Esta primera versión mantiene una configuración simple para facilitar la defensa
            académica del proyecto.
          </p>

          <div className="option-card">
            <span>Modo visual</span>
            <strong>Terminal espacial sobria</strong>
          </div>

          <div className="option-card">
            <span>Conexión lógica</span>
            <strong>Backend → SWI-Prolog</strong>
          </div>

          <div className="option-card">
            <span>Motor del juego</span>
            <strong>Prolog</strong>
          </div>
        </section>
      </main>
    )
  }

  return (
    <main className="app-shell">
      <FondoEspacial />

      <section className="game-frame">
        <header className="game-header">
          <div>
            <p className="eyebrow">CAL / AURORA / TERMINAL</p>
            <h1>Operación Atlas</h1>
          </div>

          <div className="connection-status">
            <span className={cargando ? 'pulse warning' : 'pulse'}></span>
            {cargando ? 'procesando' : 'conectado'}
          </div>
        </header>

        <div className="game-layout">
          <aside className="side-panel lore-panel">
            <div className="panel-title">BITÁCORA DE MISIÓN</div>
            <pre>{loreTexto}</pre>
          </aside>

          <section className="terminal-panel">
            <div className="terminal-topbar">
              <span></span>
              <span></span>
              <span></span>
              <p>atlas@aurora: sistema de diagnóstico</p>
            </div>

            <div className="terminal-output" ref={consolaRef}>
              {consola.map((linea, index) => (
                <pre key={index}>{linea}</pre>
              ))}
            </div>

            <div className="command-input">
              <span>atlas@aurora:~$</span>
              <input
                value={comando}
                onChange={(evento) => setComando(evento.target.value)}
                onKeyDown={manejarEnter}
                placeholder="mover(laboratorio)."
                autoFocus
              />
              <button onClick={() => ejecutarComando()}>Enviar</button>
            </div>
          </section>

          <aside className="side-panel status-panel">
            <div className="panel-title">ESTADO</div>
            <pre>{estadoTexto}</pre>
          </aside>
        </div>

        <footer className="quick-actions">
          <button onClick={() => accionRapida('estado_juego.')}>Estado</button>
          <button onClick={() => accionRapida('acciones_disponibles.')}>Acciones</button>
          <button onClick={() => accionRapida('que_tengo.')}>Inventario</button>
          <button onClick={() => accionRapida('modulos_visitados.')}>Ruta</button>
          <button onClick={() => accionRapida('como_gano.')}>Guía lógica</button>
          <button onClick={() => accionRapida('verifica_gane.')}>Verificar gane</button>
          <button onClick={() => accionRapida('reiniciar_juego.')}>Reiniciar</button>
          <button onClick={volverMenu}>Volver al menú</button>
        </footer>
      </section>
    </main>
  )
}

function FondoEspacial() {
  return (
    <div className="space-background" aria-hidden="true">
      <div className="stars stars-one"></div>
      <div className="stars stars-two"></div>
      <div className="nebula nebula-one"></div>
      <div className="nebula nebula-two"></div>
      <div className="planet planet-one"></div>
      <div className="planet planet-two"></div>
    </div>
  )
}

export default App