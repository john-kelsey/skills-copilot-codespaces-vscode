export default function LiveStream() {
  return (
    <section id="livestream" className="py-16 px-4 bg-gray-50">
      <div className="max-w-4xl mx-auto text-center">
        <span className="inline-block bg-blue-100 text-blue-800 text-xs font-semibold uppercase tracking-widest px-3 py-1 rounded-full mb-3">
          Live &amp; Recorded
        </span>
        <h2 className="text-3xl font-bold text-blue-900 mb-2">Watch Our Services</h2>
        <p className="text-gray-500 mb-8">
          Join us online every Sunday and midweek. Subscribe to our channel so you never miss a
          service.
        </p>

        {/* YouTube embed */}
        <div className="relative w-full aspect-video rounded-2xl overflow-hidden shadow-xl border border-blue-100">
          <iframe
            className="absolute inset-0 w-full h-full"
            src="https://www.youtube.com/embed?listType=user_uploads&list=deliverancechurchintlkenya3168"
            title="Deliverance Church Kenyatta Road – YouTube"
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
            allowFullScreen
          />
        </div>

        <a
          href="https://www.youtube.com/@deliverancechurchintlkenya3168"
          target="_blank"
          rel="noopener noreferrer"
          className="inline-flex items-center gap-2 mt-6 text-blue-700 hover:text-blue-900 font-medium transition-colors"
        >
          <svg className="w-5 h-5 fill-current text-red-600" viewBox="0 0 24 24">
            <path d="M23.5 6.2a3 3 0 0 0-2.1-2.1C19.5 3.5 12 3.5 12 3.5s-7.5 0-9.4.6A3 3 0 0 0 .5 6.2 31.5 31.5 0 0 0 0 12a31.5 31.5 0 0 0 .5 5.8 3 3 0 0 0 2.1 2.1c1.9.6 9.4.6 9.4.6s7.5 0 9.4-.6a3 3 0 0 0 2.1-2.1A31.5 31.5 0 0 0 24 12a31.5 31.5 0 0 0-.5-5.8zM9.75 15.5v-7l6.25 3.5-6.25 3.5z" />
          </svg>
          Visit our YouTube Channel
        </a>
      </div>
    </section>
  );
}
