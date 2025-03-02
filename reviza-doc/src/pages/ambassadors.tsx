import React from 'react';
import clsx from 'clsx';
import Layout from '@theme/Layout';
import Heading from '@theme/Heading';
import { Users, Globe, Gift } from 'lucide-react';
import styles from './ambassadors.module.css';

export default function Ambassadors(): JSX.Element {
  return (
    <Layout
      title="Become a Reviza Ambassador"
      description="Join the Reviza Student Ambassador Program and make a difference."
    >
      {/* Hero Section */}
      <header className={clsx('hero hero--primary', styles.heroBanner)}>
        <div className="container text-center">
          <Heading as="h1" className={styles.heroTitle}>
            Become a Reviza Ambassador
          </Heading>
          <p className={styles.heroSubtitle}>
            Gain leadership skills, expand your network, and help others succeed.
          </p>
          <a 
            href="#apply" 
            className="button button--secondary button--lg"
          >
            Apply Now
          </a>
        </div>
      </header>

      <main>
        {/* Benefits Section */}
        <section className={styles.benefitsSection}>
          <div className="container">
            <Heading as="h2" className={styles.sectionTitle}>Why Join?</Heading>
            <div className="row">
              <div className="col col--4">
                <div className={styles.benefitCard}>
                  <Users size={48} className={styles.icon} />
                  <h3>Leadership Experience</h3>
                  <p>Develop skills that will help you stand out in your career.</p>
                </div>
              </div>
              <div className="col col--4">
                <div className={styles.benefitCard}>
                  <Globe size={48} className={styles.icon} />
                  <h3>Expand Your Network</h3>
                  <p>Connect with like-minded students and professionals.</p>
                </div>
              </div>
              <div className="col col--4">
                <div className={styles.benefitCard}>
                  <Gift size={48} className={styles.icon} />
                  <h3>Exclusive Perks</h3>
                  <p>Enjoy rewards, recognition, and growth opportunities.</p>
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* Application Form */}
        <section id="apply" className={styles.formSection}>
          <div className="container text-center">
            <Heading as="h2">Apply Now</Heading>
            <p>Fill out the form below to apply for the Reviza Student Ambassador Program.</p>
            <div className={styles.formContainer}>
              <iframe 
                src="https://docs.google.com/forms/d/e/1FAIpQLSc560w4y7HaPdi0c69JM1BYfk3cx6a_dwCKSTFBmt-adwztpQ/viewform?embedded=true" 
                width="100%" 
                height="1370" 
                title="Reviza Ambassador Application"
              >
                Loading…
              </iframe>
            </div>
          </div>
        </section>
      </main>
    </Layout>
  );
}
