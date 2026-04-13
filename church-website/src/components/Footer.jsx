export default function Footer() {
  return (
    <footer className="bg-blue-950 text-blue-300 py-8 px-4 text-center text-sm">
      <p className="font-semibold text-white mb-1">Deliverance Church Kenyatta Road</p>
      <p className="mb-1">Kenyatta Road Juja – Exit 14 off Thika Superhighway</p>
      <p className="mb-4">Opposite Bristar Girls High School, 4th Avenue</p>
      <p className="text-blue-500 text-xs">
        &copy; {new Date().getFullYear()} Deliverance Church Kenyatta Road. All rights reserved.
      </p>
    </footer>
  );
}
