import { useState, useEffect } from 'react';

export default function Materials() {
  const [materials, setMaterials] = useState([]);
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
            <a href={material.file} target="_blank" rel="noopener noreferrer">
              {material.title} - {material.course_name}
            </a>
            <p>{material.description}</p>
          </li>
        ))}
      </ul>
    </div>
  );
}
