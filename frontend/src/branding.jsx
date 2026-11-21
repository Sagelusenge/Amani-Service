import React from 'react';

export function BrandLogo({className = '', decorative = false}) {
  return <img className={`amani-logo ${className}`} src="/images/amani-logo.png" alt={decorative ? '' : 'Amani Services'} decoding="async"/>;
}

export function BrandLoader({label = 'Chargement des données…'}) {
  return <div className="amani-loader" role="status" aria-live="polite" aria-busy="true">
    <BrandLogo decorative/>
    <span className="amani-loader-track" aria-hidden="true"/>
    <span>{label}</span>
  </div>;
}
