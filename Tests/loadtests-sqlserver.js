// Extensao do k6 para SQL Server:
// https://github.com/grafana/xk6-sql
// https://k6.io/blog/load-testing-sql-databases-with-k6/

import sql from 'k6/x/sql';
import { check } from 'k6';
import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import { textSummary } from "https://jslib.k6.io/k6-summary/0.0.1/index.js";

export const options = {
    iterations: 50,
    vus: 10
};

const db = sql.open("sqlserver", "#{ConnectionStringSqlServer}#");

export function teardown() {
  console.log('Fechando a conexao com o SQL Server...');
  db.close();
}

export default function () {
    const results = sql.query(db, `SELECT * FROM demo.Vendas WHERE Dt_Venda >= '2022-01-01' AND [Status] = 'D' AND Quantidade = 2;`);

    check(results, {
        'Vendas encontradas': (r) => r.length > 0,
    });
}

export function handleSummary(data) {
    return {
      "loadtests-sqlserver.html": htmlReport(data),
      stdout: textSummary(data, { indent: " ", enableColors: true })
    };
}