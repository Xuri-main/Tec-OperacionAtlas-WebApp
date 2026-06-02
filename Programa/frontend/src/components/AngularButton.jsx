export default function AngularButton({ children, variant = 'secondary', onClick }) {
  return (
    <button className={`atlas-angular-button ${variant}`} onClick={onClick}>
      <span className="button-scan"></span>
      <span className="button-text">{children}</span>
      <span className="corner corner-top-left"></span>
      <span className="corner corner-bottom-right"></span>
    </button>
  )
}