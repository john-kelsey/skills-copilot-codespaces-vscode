const STEPS = [
  { step: '1', text: 'Go to M-Pesa on your phone' },
  { step: '2', text: 'Select "Lipa na M-Pesa"' },
  { step: '3', text: 'Select "Pay Bill"' },
  { step: '4', text: 'Enter Business Number: 000000' },
  { step: '5', text: 'Account Name: DELIVERANCE CHURCH K-ROAD' },
  { step: '6', text: 'Enter amount and your M-Pesa PIN' },
];

export default function Donation() {
  return (
    <section id="give" className="py-16 px-4 bg-blue-900 text-white">
      <div className="max-w-3xl mx-auto text-center">
        <span className="inline-block bg-blue-700 text-blue-200 text-xs font-semibold uppercase tracking-widest px-3 py-1 rounded-full mb-3">
          Give
        </span>
        <h2 className="text-3xl font-bold mb-2">Support the Ministry</h2>
        <p className="text-blue-200 mb-10">
          Your generous giving helps us serve our community and spread the Gospel.
        </p>

        <div className="bg-blue-800 rounded-2xl p-8 shadow-lg">
          {/* M-Pesa badge */}
          <div className="flex items-center justify-center gap-3 mb-6">
            <div className="bg-green-500 text-white font-extrabold px-4 py-2 rounded-lg text-xl tracking-wide">
              M-PESA
            </div>
          </div>

          <div className="grid sm:grid-cols-2 gap-4 mb-6 text-left">
            <div className="bg-blue-700 rounded-xl p-4">
              <p className="text-blue-300 text-xs uppercase tracking-widest mb-1">Paybill Number</p>
              <p className="text-2xl font-bold">000000</p>
              <p className="text-blue-300 text-xs mt-1">(placeholder)</p>
            </div>
            <div className="bg-blue-700 rounded-xl p-4">
              <p className="text-blue-300 text-xs uppercase tracking-widest mb-1">Account Name</p>
              <p className="text-lg font-bold leading-snug">DELIVERANCE CHURCH K-ROAD</p>
            </div>
          </div>

          <h3 className="text-left text-sm font-semibold text-blue-200 uppercase tracking-widest mb-4">
            How to Give
          </h3>
          <ol className="space-y-2 text-left">
            {STEPS.map((s) => (
              <li key={s.step} className="flex items-start gap-3 text-sm">
                <span className="flex-shrink-0 w-6 h-6 rounded-full bg-blue-600 flex items-center justify-center text-xs font-bold">
                  {s.step}
                </span>
                <span className="text-blue-100">{s.text}</span>
              </li>
            ))}
          </ol>
        </div>
      </div>
    </section>
  );
}
