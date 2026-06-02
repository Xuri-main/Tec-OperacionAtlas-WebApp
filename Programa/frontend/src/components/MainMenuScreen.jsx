import SpaceMenuBackground from './SpaceMenuBackground'
import MainMenuPanel from './MainMenuPanel'
import { StatusIndicators, SystemInfo } from './StatusIndicators'

export default function MainMenuScreen({
  onStart,
  onHowToPlay,
  onOptions,
  onRepository
}) {
  return (
    <main className="atlas-menu-screen">
      <SpaceMenuBackground />

      <div className="atlas-menu-center">
        <MainMenuPanel
          onStart={onStart}
          onHowToPlay={onHowToPlay}
          onOptions={onOptions}
          onRepository={onRepository}
        />
      </div>

      <StatusIndicators />
      <SystemInfo />

      <button className="help-orb" type="button">?</button>
    </main>
  )
}