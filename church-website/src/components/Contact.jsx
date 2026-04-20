export default function Contact() {
  return (
    <section id="contact" className="py-16 px-4 bg-gray-50">
      <div className="max-w-5xl mx-auto text-center">
        <span className="inline-block bg-blue-100 text-blue-800 text-xs font-semibold uppercase tracking-widest px-3 py-1 rounded-full mb-3">
          Find Us
        </span>
        <h2 className="text-3xl font-bold text-blue-900 mb-2">Contact &amp; Location</h2>
        <p className="text-gray-500 mb-10">We'd love to see you in person or hear from you!</p>

        <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {/* Address */}
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 text-left">
            <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center mb-4">
              <svg className="w-5 h-5 text-blue-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
              </svg>
            </div>
            <h3 className="font-bold text-blue-900 mb-2">Address</h3>
            <p className="text-sm text-gray-600 leading-relaxed">
              Kenyatta Road Juja<br />
              Exit 14 off Thika Superhighway<br />
              Opposite Bristar Girls High School<br />
              4th Avenue
            </p>
          </div>

          {/* Phone */}
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 text-left">
            <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center mb-4">
              <svg className="w-5 h-5 text-blue-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
              </svg>
            </div>
            <h3 className="font-bold text-blue-900 mb-2">Phone</h3>
            {/* TODO: Replace with the actual church phone number before going live */}
            <p className="text-sm text-gray-600">+254 700 000 000</p>
            <p className="text-xs text-gray-400 mt-1">(placeholder)</p>
          </div>

          {/* Email */}
          <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 text-left">
            <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center mb-4">
              <svg className="w-5 h-5 text-blue-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
              </svg>
            </div>
            <h3 className="font-bold text-blue-900 mb-2">Email</h3>
            {/* TODO: Replace with the actual church email address before going live */}
            <p className="text-sm text-gray-600">info@dckroad.org</p>
            <p className="text-xs text-gray-400 mt-1">(placeholder)</p>
          </div>
        </div>

        {/* Social media */}
        <div className="mt-10 flex flex-wrap justify-center gap-4">
          <a
            href="https://www.facebook.com/dckroad"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 bg-blue-600 hover:bg-blue-700 text-white font-semibold px-5 py-2.5 rounded-full transition-colors text-sm"
          >
            <svg className="w-4 h-4 fill-current" viewBox="0 0 24 24">
              <path d="M24 12.073C24 5.405 18.627 0 12 0S0 5.405 0 12.073C0 18.1 4.388 23.094 10.125 24v-8.437H7.078v-3.49h3.047V9.41c0-3.025 1.791-4.697 4.533-4.697 1.312 0 2.686.236 2.686.236v2.97h-1.513c-1.491 0-1.956.93-1.956 1.883v2.272h3.328l-.532 3.49h-2.796V24C19.612 23.094 24 18.1 24 12.073z" />
            </svg>
            Facebook – dckroad
          </a>
          <a
            href="https://www.youtube.com/@deliverancechurchintlkenya3168"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 bg-red-600 hover:bg-red-700 text-white font-semibold px-5 py-2.5 rounded-full transition-colors text-sm"
          >
            <svg className="w-4 h-4 fill-current" viewBox="0 0 24 24">
              <path d="M23.5 6.2a3 3 0 0 0-2.1-2.1C19.5 3.5 12 3.5 12 3.5s-7.5 0-9.4.6A3 3 0 0 0 .5 6.2 31.5 31.5 0 0 0 0 12a31.5 31.5 0 0 0 .5 5.8 3 3 0 0 0 2.1 2.1c1.9.6 9.4.6 9.4.6s7.5 0 9.4-.6a3 3 0 0 0 2.1-2.1A31.5 31.5 0 0 0 24 12a31.5 31.5 0 0 0-.5-5.8zM9.75 15.5v-7l6.25 3.5-6.25 3.5z" />
            </svg>
            YouTube
          </a>
        </div>
      </div>
    </section>
  );
}
