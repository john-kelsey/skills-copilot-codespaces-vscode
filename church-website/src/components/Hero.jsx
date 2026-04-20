export default function Hero() {
  return (
    <section
      id="home"
      className="relative bg-gradient-to-br from-blue-900 via-blue-800 to-blue-600 text-white py-24 px-4 text-center overflow-hidden"
    >
      {/* Decorative circles */}
      <div className="absolute -top-16 -left-16 w-64 h-64 rounded-full bg-blue-700 opacity-30" />
      <div className="absolute -bottom-20 -right-20 w-80 h-80 rounded-full bg-blue-500 opacity-20" />

      <div className="relative max-w-3xl mx-auto">
        <p className="uppercase tracking-widest text-blue-300 text-xs mb-4">Welcome to</p>
        <h1 className="text-4xl sm:text-5xl md:text-6xl font-extrabold leading-tight mb-4">
          Deliverance Church
          <br />
          <span className="text-blue-300">Kenyatta Road</span>
        </h1>
        <p className="text-xl sm:text-2xl italic text-blue-100 mb-8">
          "A House of Love, Care and Restoration"
        </p>
        <div className="flex flex-wrap justify-center gap-4">
          <a
            href="#services"
            className="bg-white text-blue-900 font-semibold px-6 py-3 rounded-full hover:bg-blue-100 transition-colors"
          >
            Service Times
          </a>
          <a
            href="#livestream"
            className="border border-white text-white font-semibold px-6 py-3 rounded-full hover:bg-white hover:text-blue-900 transition-colors"
          >
            Watch Live
          </a>
        </div>
      </div>
    </section>
  );
}
