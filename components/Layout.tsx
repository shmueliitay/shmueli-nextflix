import React, { ReactNode } from 'react';

type LayoutProps = {
  children: ReactNode;
};

const Layout = ({ children }: LayoutProps) => {
  return (
    <div>
      <header style={{ padding: '1rem', background: '#222', color: '#fff' }}>
        <h1>Nextflix 🎬</h1>
      </header>
      <main>{children}</main>
      <footer style={{ padding: '1rem', background: '#eee', textAlign: 'center' }}>
        © 2025 Nextflix
      </footer>
    </div>
  );
};

export default Layout;

