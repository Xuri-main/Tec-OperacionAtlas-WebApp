import AngularButton from './AngularButton'

export default function MainMenuPanel({
  onStart,
  onHowToPlay,
  onOptions,
  onRepository
}) {
  return (
    <section className="atlas-menu-panel">
      <div className="panel-glow"></div>

      <div className="panel-line panel-line-top"></div>
      <div className="panel-line panel-line-bottom"></div>

      <div className="panel-dots">
        <span></span>
        <span></span>
        <span></span>
      </div>

      <div className="panel-content">
        <p className="protocol-label">INICIANDO PROTOCOLO</p>

        <h1 className="atlas-title">
          OPERACIÓN
          <span>ATLAS</span>
        </h1>

        <div className="title-separator">
          <span></span>
          <i></i>
          <span></span>
        </div>

        <div className="menu-button-group">
          <AngularButton variant="primary" onClick={onStart}>
            Iniciar Juego
          </AngularButton>

          <AngularButton variant="secondary" onClick={onHowToPlay}>
            Cómo Jugar
          </AngularButton>

          <AngularButton variant="secondary" onClick={onOptions}>
            Opciones
          </AngularButton>

          <div className="repo-button-wrap">
            <AngularButton variant="tertiary" onClick={onRepository}>
              Ver Repositorio
            </AngularButton>
          </div>
        </div>

        <div className="mission-status-bar">
          <div>
            <span className="status-dot green"></span>
            READY
          </div>

          <span className="status-divider"></span>

          <div>
            <span className="status-dot cyan"></span>
            AWAITING INPUT
          </div>
        </div>
      </div>

      <span className="tech-corner tech-corner-top"></span>
      <span className="tech-corner tech-corner-bottom"></span>
    </section>
  )
}