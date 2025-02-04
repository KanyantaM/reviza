import React from 'react';
import clsx from 'clsx';
import Layout from '@theme/Layout';
import Heading from '@theme/Heading';

import styles from './downloads.module.css';
import Waitlist from '../components/wait_list';

const downloadLinks = [
  {
    name: 'App Store',
    icon: 'https://upload.wikimedia.org/wikipedia/commons/6/67/App_Store_%28iOS%29.svg', 
    link: 'https://apps.apple.com', // Replace with actual link
    description: 'Get the ReviZa app for your iPhone or iPad.',
  },
  {
    name: 'Play Store',
    icon: 'https://upload.wikimedia.org/wikipedia/commons/5/55/Google_Play_2016_icon.svg',
    link: 'https://play.google.com/store', // Replace with actual link
    description: 'Download ReviZa for your Android device.',
  },
  {
    name: 'Windows',
    icon: 'https://upload.wikimedia.org/wikipedia/commons/c/c4/Windows_logo_-_2021_%28Black%29.svg',
    link: 'https://example.com/windows', // Replace with actual link
    description: 'Download the ReviZa app for Windows.',
  },
  {
    name: 'Mac',
    icon: 'https://upload.wikimedia.org/wikipedia/commons/a/ab/Icon-Mac.svg',
    link: 'https://example.com/mac', // Replace with actual link
    description: 'Download ReviZa for your macOS device.',
  },
//   {
//     name: 'Online',
//     icon: '/img/net.svg', 
//     link: 'https://reviza.com', // Replace with the actual website link
//     description: 'Use ReviZa directly in your browser.',
//   },
];

function DownloadCard({ name, icon, link, description }) {
  return (
    <div className={clsx('col col--4')}>
      <div className={styles.card}>
        <img src={icon} alt={`${name} icon`} className={styles.icon} />
        <Heading as="h3" className={styles.cardTitle}>
          {name}
        </Heading>
        <p className={styles.cardDescription}>{description}</p>
        <a href={link} target="_blank" rel="noopener noreferrer" className="button button--primary">
          Download
        </a>
      </div>
    </div>
  );
}

export default function Downloads(): JSX.Element {
  return (
    <Layout
      title="Download ReviZa"
      description="Download ReviZa on your preferred platform and start studying smarter today!"
    >
      <header className={clsx('hero hero--primary', styles.heroBanner)}>
        <div className="container">
          <Heading as="h1" className={styles.heroTitle}>
            Download ReviZa
          </Heading>
          <p className={styles.heroSubtitle}>
            Choose your platform and start your learning journey with ReviZa.
          </p>
        </div>
        <div><Waitlist/></div>
      </header>
      <main>
        <section className={styles.downloadSection}>
          <div className="container">
            <div className="row">
              {downloadLinks.map((item, idx) => (
                <DownloadCard key={idx} {...item} />
              ))}
            </div>
          </div>
        </section>
      </main>
    </Layout>
  );
}
