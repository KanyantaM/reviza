import React from 'react';
import clsx from 'clsx';
import styles from './styles.module.css';

const features = [
  {
    title: 'Share Study Materials',
    description: 'Easily upload, organize, and share your study resources with classmates and peers across your university.',
    imgSrc: '/img/share_study_materials.svg',
  },
  {
    title: 'Collaborative Learning',
    description: 'Engage in discussions, get feedback on shared resources, and learn together in a dynamic environment.',
    imgSrc: '/img/collaborative_learning.svg',
  },
  {
    title: 'Smart Organization',
    description: 'Keep your materials sorted by course, type, and importance to quickly find what you need when you need it.',
    imgSrc: '/img/smart_organization.svg',
  },
  {
    title: 'Cross-Platform Access',
    description: 'Use ReviZa on any device—whether you’re on your phone, tablet, or desktop, your materials are always accessible.',
    imgSrc: '/img/cross_platform_access.svg',
  },
  {
    title: 'Insightful Analytics',
    description: 'Track the impact of your contributions with statistics like downloads, upvotes, and interactions.',
    imgSrc: '/img/insightful_analytics.svg',
  },
];

function FeatureCard({ title, description, imgSrc }: { title: string; description: string; imgSrc: string }) {
  return (
    <div className={clsx(styles.featureCard)}>
      <div className={styles.featureImageContainer}>
        <img src={imgSrc} alt={title} className={styles.featureImage} />
      </div>
      <div className={styles.featureText}>
        <h3 className={styles.featureTitle}>{title}</h3>
        <p className={styles.featureDescription}>{description}</p>
      </div>
    </div>
  );
}

export default function ReviZaFeatures(): JSX.Element {
  return (
    <section className={styles.featuresSection}>
      <div className={styles.container}>
        <h2 className={styles.featuresHeader}>Why Choose ReviZa?</h2>
        <p className={styles.featuresTagline}>
          Empowering students with tools to share, collaborate, and succeed.
        </p>
        <div className={styles.featuresGrid}>
          {features.map((feature, idx) => (
            <FeatureCard
              key={idx}
              title={feature.title}
              description={feature.description}
              imgSrc={feature.imgSrc}
            />
          ))}
        </div>
      </div>
    </section>
  );
}
