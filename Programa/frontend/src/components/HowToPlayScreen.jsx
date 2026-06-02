import SpaceMenuBackground from './SpaceMenuBackground'

export default function HowToPlayScreen({ onBack, onStart }) {
  return (
    <main className="how-page">
      <SpaceMenuBackground />

      <div className="how-top-label">
        CAL // ESTACIÓN AURORA
      </div>

      <div className="how-top-controls">
        <button className="how-control-button" onClick={onBack}>
          ← MENÚ
        </button>
      </div>

      <section className="how-content">
        <div className="how-panel">
          <span className="how-corner top-left"></span>
          <span className="how-corner bottom-right"></span>

          <header className="how-header">
            <p>MANUAL DE INSTRUCCIONES // PROTOCOLO ATLAS</p>
            <h1>
              GUÍA DE <span>OPERACIÓN</span>
            </h1>
          </header>

          <div className="how-scroll-area">
            <section className="how-section">
              <div className="how-section-title cyan">
                <span className="how-icon">◇</span>
                <h2>OBJETIVO DE LA MISIÓN</h2>
              </div>

              <p>
                Una tormenta solar ha desestabilizado la{' '}
                <strong>Estación Aurora</strong>. Su misión es reparar los
                sistemas críticos, rescatar a la tripulación atrapada y restaurar
                el control de la estación.
              </p>
            </section>

            <section className="how-section">
              <div className="how-section-title green">
                <span className="how-icon">▣</span>
                <h2>CÓMO JUGAR</h2>
              </div>

              <p>
                Este es un juego de <strong>aventura de texto</strong> basado en
                lógica. El jugador interactúa escribiendo comandos en la terminal
                de ingeniería.
              </p>

              <p className="how-note">
                Todos los comandos deben escribirse con la forma de una consulta
                lógica y terminar con punto.
              </p>
            </section>

            <section className="how-section">
              <div className="how-section-title amber">
                <span className="how-icon">✦</span>
                <h2>COMANDOS PRINCIPALES</h2>
              </div>

              <div className="how-command-grid">
                <CommandCard
                  command="acciones_disponibles."
                  description="Muestra las acciones que puede realizar en el estado actual."
                />

                <CommandCard
                  command="estado_juego."
                  description="Consulta la ubicación, inventario, sistemas y tripulantes."
                />

                <CommandCard
                  command="mover(laboratorio)."
                  description="Intenta mover al jugador hacia un módulo conectado."
                />

                <CommandCard
                  command="tomar(fusible)."
                  description="Toma un artefacto si está en el módulo actual."
                />

                <CommandCard
                  command="usar(traje_espacial)."
                  description="Registra el uso de un artefacto para desbloquear restricciones."
                />

                <CommandCard
                  command="reparar(energia)."
                  description="Restaura un sistema si cumple las condiciones necesarias."
                />

                <CommandCard
                  command="rescatar(elena)."
                  description="Rescata a un tripulante si está en el mismo módulo y los sistemas funcionan."
                />

                <CommandCard
                  command="verifica_gane."
                  description="Comprueba si todos los objetivos de victoria fueron cumplidos."
                />
              </div>
            </section>

            <section className="how-section">
              <div className="how-section-title cyan">
                <span className="how-icon">!</span>
                <h2>CONSEJOS DE MISIÓN</h2>
              </div>

              <ul className="how-tips">
                <li>
                  Use <code>acciones_disponibles.</code> cuando no sepa qué hacer.
                </li>
                <li>
                  Use <code>donde_esta(Artefacto).</code> para localizar objetos.
                </li>
                <li>
                  Algunos módulos requieren artefactos usados previamente.
                </li>
                <li>
                  Algunos rescates requieren sistemas reparados.
                </li>
                <li>
                  La lógica es clave: piense en el orden de las acciones.
                </li>
              </ul>
            </section>
          </div>
        </div>

        <button className="how-start-button" onClick={onStart}>
          INICIAR MISIÓN
        </button>
      </section>
    </main>
  )
}

function CommandCard({ command, description }) {
  return (
    <div className="how-command-card">
      <code>{command}</code>
      <p>{description}</p>
    </div>
  )
}