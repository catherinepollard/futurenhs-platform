import React from "react";
import { GetServerSideProps } from 'next';
import Head from "next/head";
import Layout from "../components/layout";
import utilStyles from "../styles/utils.module.css";

interface Doctor {
  name: string;
}
interface Props {
  data: {
    doctors: Doctor[]
  }
}

const Home = ({ data }: Props) =>
  <Layout home>
    <Head>
      <title>FutureNHS</title>
    </Head>
    <section className={utilStyles.headingMd}>
      <p>FutureNHS</p>
      <ul>
        {data && data.doctors.map(dr => <li key={dr.name}>{dr.name}</li>)}
      </ul>
    </section>
  </Layout>

export const getServerSideProps: GetServerSideProps = async () => {
  const headers = {
    "X-Correlation-ID": "9999"
  };
  const res = await fetch(`http://localhost:3030/doctors`, { headers });
  const data = await res.json();
  return { props: { data } }
}

export default Home;
