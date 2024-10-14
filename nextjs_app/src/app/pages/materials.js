import { useState, useEffect } from 'react';
import { Worker, Viewer } from '@react-pdf-viewer/core';
import '@react-pdf-viewer/core/lib/styles/index.css';
import '@react-pdf-viewer/default-layout/lib/styles/index.css';

export default function Materials() {
  const [materials, setMaterials] = useState([]);
  const [selectedPdf, setSelectedPdf] = useState(null);
  const [loading, setLoading] = useState(true);
  const apiUrl = process.env.NEXT_PUBLIC_API_URL;

  useEffect(() => {
    async function fetchMaterials() {
      try {
        const response = await fetch(apiUrl);
        const data = await response.json();
        setMaterials(data);
      } catch (error) {
        console.error('Error fetching study materials:', error);
      } finally {
        setLoading(false);
      }
    }

    fetchMaterials();
  }, [apiUrl]);

  if (loading) {
    return <p>Loading study materials...</p>;
  }

  return (
    <div>
      <h1>Study Materials</h1>
      <ul>
        {materials.map((material) => (
          <li key={material.id}>
            <a onClick={() => setSelectedPdf(material.file)}>
              {material.title} - {material.course_name}
            </a>
            <p>{material.description}</p>
          </li>
        ))}
      </ul>

      {selectedPdf && (
        <div>
          <h2>Selected PDF</h2>
          <Worker workerUrl={`https://unpkg.com/pdfjs-dist@2.5.207/build/pdf.worker.min.js`}>
            <div style={{ height: '750px' }}>
              <Viewer fileUrl={selectedPdf} />
            </div>
          </Worker>
        </div>
      )}
    </div>
  );
}
