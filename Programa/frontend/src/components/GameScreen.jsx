export default function GameScreen({
  consola,
  comando,
  setComando,
  ejecutarComando,
  manejarEnter,
  cargando,
  volverMenu,
  victoria
}) {
  const quickActions = [
    { label: 'Estado', command: 'estado_juego.' },
    { label: 'Acciones', command: 'acciones_disponibles.' },
    { label: 'Inventario', command: 'que_tengo.' },
    { label: 'Ruta', command: 'modulos_visitados.' },
    { label: 'Guía lógica', command: 'como_gano.' },
    { label: 'Verificar gane', command: 'verifica_gane.' },
    { label: 'Reiniciar', command: 'reiniciar_juego.' }
  ]

  return (
    <section className="atlas-game-screen">
      <div className="game-top-label">
        CAL // ESTACIÓN AURORA
      </div>

      <div className="game-top-controls">
        <button className="game-control-button" onClick={volverMenu}>
          ← MENÚ
        </button>

      </div>

      <div className="game-terminal-wrapper">
        <div className={`game-terminal ${victoria ? 'victory-terminal' : ''}`}>
          <header className="game-terminal-header">
            <div className="terminal-header-left">
              <span className="mini-dot cyan"></span>
              <span className="mini-dot green"></span>
              <strong>OPERACIÓN ATLAS // TERMINAL DE INGENIERÍA</strong>
            </div>

            <span className="terminal-core-status">
              {cargando ? 'PROLOG CORE PROCESSING' : 'PROLOG CORE ONLINE'}
            </span>
          </header>

          <div className="game-console-output">
            {consola.map((linea, index) => (
              <ConsoleLine key={`${linea}-${index}`} text={linea} />
            ))}

            <div className="terminal-cursor-line">
              <span className="terminal-block-cursor">█</span>
            </div>
          </div>

          <div className="game-command-zone">
            <div className="game-command-input-row">
              <span className="terminal-prefix">atlas@aurora:~$</span>

              <input
                value={comando}
                onChange={(evento) => setComando(evento.target.value)}
                onKeyDown={manejarEnter}
                placeholder="mover(laboratorio)."
                disabled={cargando}
                autoFocus
              />

              <button onClick={() => ejecutarComando()} disabled={cargando}>
                ENVIAR
              </button>
            </div>

            <div className="game-quick-actions">
              {quickActions.map((action) => (
                <button
                  key={action.label}
                  onClick={() => ejecutarComando(action.command)}
                  disabled={cargando}
                >
                  {action.label}
                </button>
              ))}
            </div>
          </div>

          <span className="terminal-corner top-left"></span>
          <span className="terminal-corner bottom-right"></span>
        </div>

        <div className="game-footer-meta">
          <span>SYSTEM READY</span>
          <span>BUILD 20260602</span>
        </div>
      </div>

      {victoria && (
        <div className="victory-overlay">
          <div className="victory-card">
            <p>PROTOCOLO ATLAS FINALIZADO</p>
            <h2>MISIÓN COMPLETADA</h2>
            <span>ESTACIÓN AURORA RESTAURADA</span>
            <span>TRIPULACIÓN RESCATADA</span>

            <button onClick={volverMenu}>
              VOLVER AL MENÚ PRINCIPAL
            </button>
          </div>
        </div>
      )}

      <button className="game-help-orb" type="button">?</button>
    </section>
  )
}

function ConsoleLine({ text }) {
  let className = 'console-line normal'

  if (text.startsWith('[SISTEMA]')) {
    className = 'console-line system'
  } else if (text.startsWith('[CAL]')) {
    className = 'console-line warning'
  } else if (text.startsWith('[MISIÓN]')) {
    className = 'console-line mission'
  } else if (text.startsWith('[TERMINAL]')) {
    className = 'console-line terminal-note'
  } else if (text.startsWith('atlas@aurora')) {
    className = 'console-line command'
  } else if (text.includes('CONDICION DE VICTORIA') || text.includes('VICTORIA')) {
    className = 'console-line victory'
  } else if (
    text.includes('No es posible') ||
    text.includes('ERROR') ||
    text.includes('No se puede') ||
    text.includes('no puedes')
  ) {
    className = 'console-line danger'
  } else if (
    text.includes('reparado') ||
    text.includes('rescatado') ||
    text.includes('tomado') ||
    text.includes('usado') ||
    text.includes('Te moviste')
  ) {
    className = 'console-line success'
  }

  return (
    <pre className={className}>
      {text}
    </pre>
  )
}