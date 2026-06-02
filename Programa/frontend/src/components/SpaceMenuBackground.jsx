export default function SpaceMenuBackground() {
  const stars = Array.from({ length: 95 }, (_, index) => ({
    id: index,
    left: `${Math.random() * 100}%`,
    top: `${Math.random() * 100}%`,
    size: `${Math.random() * 2 + 0.6}px`,
    opacity: Math.random() * 0.7 + 0.25,
    delay: `${Math.random() * 4}s`,
    duration: `${Math.random() * 4 + 3}s`
  }))

  const particles = Array.from({ length: 24 }, (_, index) => ({
    id: index,
    left: `${Math.random() * 100}%`,
    top: `${Math.random() * 100}%`,
    delay: `${Math.random() * 8}s`,
    duration: `${Math.random() * 18 + 15}s`
  }))

  return (
    <div className="atlas-space-background" aria-hidden="true">
      <div className="space-nebula nebula-one"></div>
      <div className="space-nebula nebula-two"></div>
      <div className="space-nebula nebula-three"></div>

      <div className="distant-planet planet-a"></div>
      <div className="distant-planet planet-b"></div>

      {stars.map((star) => (
        <span
          key={star.id}
          className="space-star"
          style={{
            left: star.left,
            top: star.top,
            width: star.size,
            height: star.size,
            opacity: star.opacity,
            animationDelay: star.delay,
            animationDuration: star.duration
          }}
        ></span>
      ))}

      {particles.map((particle) => (
        <span
          key={particle.id}
          className="space-particle"
          style={{
            left: particle.left,
            top: particle.top,
            animationDelay: particle.delay,
            animationDuration: particle.duration
          }}
        ></span>
      ))}

      <div className="scan-lines"></div>
      <div className="dark-vignette"></div>
    </div>
  )
}