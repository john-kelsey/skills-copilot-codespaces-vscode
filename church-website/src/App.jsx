import Navbar from './components/Navbar';
import Hero from './components/Hero';
import LiveStream from './components/LiveStream';
import Services from './components/Services';
import Donation from './components/Donation';
import Contact from './components/Contact';
import Footer from './components/Footer';

export default function App() {
  return (
    <div className="min-h-screen flex flex-col">
      <Navbar />
      <main className="flex-1">
        <Hero />
        <LiveStream />
        <Services />
        <Donation />
        <Contact />
      </main>
      <Footer />
    </div>
  );
}
