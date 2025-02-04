import React from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import Heading from '@theme/Heading';

import styles from './index.module.css';
import ReviZaFeatures from '@site/src/components/HomepageFeatures';
import Waitlist from '../components/wait_list';

function HomepageHeader() {
  const { siteConfig } = useDocusaurusContext();
  return (
    <header className={clsx('hero', styles.heroBanner)}>
      <div className="container">
        <div className={styles.heroContent}>
          <Heading as="h1" className={styles.heroTitle}>
            {siteConfig.title}
          </Heading>
          <p className={styles.heroSubtitle}>{siteConfig.tagline}</p>
          <div className={styles.buttons}>
            <Link
              className="button button--secondary button--lg"
              to="/docs/intro"
            >
              Get to Know ReviZa - 5min ⏱️
            </Link>
            <Link className="button button--outline button--lg" to="/download">
              Download
            </Link>
          </div>
        </div>
        <div className={styles.heroImage}>
          <img
            src="/img/hero_image.png"
            alt="ReviZa Hero"
            className={styles.heroImageStyles}
          />
        </div>
      </div>
    </header>
  );
}

function CallToAction() {
  return (
    <section className={clsx(styles.ctaSection, 'text--center')}>
      <div className="container">
        <h2 className={styles.ctaTitle}>
          Ready to Collaborate and Share Knowledge?
        </h2>
        <p className={styles.ctaSubtitle}>
          Discover the power of collaboration with ReviZa, where students come
          together to excel.
        </p>
        <Link className="button button--primary button--lg" to="/download">
          Download Now
        </Link>
      </div>
    </section>
  );
}

export default function Home(): JSX.Element {
  const { siteConfig } = useDocusaurusContext();
  return (
    <Layout
      title={`Welcome to ${siteConfig.title}`}
      description="ReviZa - Making higher education easier for everyone."
    >
      <HomepageHeader />
      <Waitlist />
      <main>
        <ReviZaFeatures />
        <CallToAction />
      </main>
    </Layout>
  );
}
