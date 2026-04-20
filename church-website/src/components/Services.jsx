const SCHEDULE = [
  {
    day: 'Sunday',
    icon: '🙏',
    services: [
      { name: 'Intercessory Prayer', time: '8:30 AM' },
      { name: 'Main Service', time: '9:00 AM' },
    ],
  },
  {
    day: 'Wednesday',
    icon: '📖',
    services: [{ name: 'Midweek Service', time: '6:30 PM' }],
  },
  {
    day: 'Tuesday & Thursday',
    icon: '🏡',
    services: [{ name: 'Home Fellowship', time: '6:30 PM' }],
  },
];

export default function Services() {
  return (
    <section id="services" className="py-16 px-4 bg-white">
      <div className="max-w-5xl mx-auto text-center">
        <span className="inline-block bg-blue-100 text-blue-800 text-xs font-semibold uppercase tracking-widest px-3 py-1 rounded-full mb-3">
          Schedule
        </span>
        <h2 className="text-3xl font-bold text-blue-900 mb-2">Service Times</h2>
        <p className="text-gray-500 mb-10">Come worship with us – all are welcome!</p>

        <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {SCHEDULE.map((item) => (
            <div
              key={item.day}
              className="bg-blue-50 border border-blue-100 rounded-2xl p-6 text-left shadow-sm hover:shadow-md transition-shadow"
            >
              <div className="text-3xl mb-3">{item.icon}</div>
              <h3 className="text-lg font-bold text-blue-900 mb-3">{item.day}</h3>
              <ul className="space-y-2">
                {item.services.map((s) => (
                  <li key={s.name} className="flex justify-between text-sm">
                    <span className="text-gray-700">{s.name}</span>
                    <span className="font-semibold text-blue-700">{s.time}</span>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
