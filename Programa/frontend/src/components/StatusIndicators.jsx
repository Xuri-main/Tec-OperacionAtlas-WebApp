export function StatusIndicators() {
  return (
    <div className="atlas-status-indicators">
      <div className="online-row">
        <span className="online-dot"></span>
        <span>SYSTEM ONLINE</span>
      </div>

      <div className="station-info">
        <p>CAL // ESTACIÓN AURORA</p>
        <small>COORD: 41.3851° N, 2.1734° E</small>
      </div>

      <div className="mission-control-line">
        <span></span>
        <small>MISSION CONTROL</small>
      </div>
    </div>
  )
}

export function SystemInfo() {
  return (
    <div className="atlas-system-info">
      <small>v2.4.7 // BUILD 20260602</small>

      <div>
        <span>ATLAS PROTOCOL</span>
        <i></i>
      </div>
    </div>
  )
}