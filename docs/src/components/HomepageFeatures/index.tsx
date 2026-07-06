import type {ReactNode} from 'react';
import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

type FeatureItem = {
  title: string;
  description: ReactNode;
};

const FeatureList: FeatureItem[] = [
  {
    title: '🚫 No Material or Cupertino',
    description: (
      <>
        Every widget imports only from <code>flutter/widgets.dart</code>. Drop
        catalyst_ui into any Flutter app without pulling in Material or
        Cupertino.
      </>
    ),
  },
  {
    title: '🎨 Typed theme system',
    description: (
      <>
        Colour scheme, typography, motion, shadows, and tokens are strongly
        typed and read through <code>BuildContext</code> extensions.
      </>
    ),
  },
  {
    title: '🧩 Open variants & tones',
    description: (
      <>
        Variants and tones are abstract classes — subclass them and{' '}
        <code>resolve</code> to any style, rather than being locked to a fixed
        enum.
      </>
    ),
  },
  {
    title: '⚛️ Atomic design',
    description: (
      <>
        Components are organised into atoms, molecules, and organisms so you can
        find the right building block fast.
      </>
    ),
  },
];

function Feature({title, description}: FeatureItem) {
  return (
    <div className={clsx('col col--3')}>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): ReactNode {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
