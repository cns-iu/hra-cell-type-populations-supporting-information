import { SparqlEndpointFetcher } from 'fetch-sparql-endpoint';
import { BlankNode, Store } from 'oxigraph';
import Papa from 'papaparse';

/**
 * Extract the value from a given oxigraph node
 *
 * @param {Node} node a node from the database
 * @returns the unwrapped value from the node
 */
function nodeValue(node) {
  if (!node) {
    return undefined;
  } else if (node instanceof BlankNode) {
    return `bn-${node.value}`;
  } else {
    return node.value;
  }
}

/**
 * A class for running sparql queries
 */
export class SparqlRunner {
  constructor() {
    this.engine = new Store();
  }

  /**
   * @returns the underlying oxigraph engine
   */
  getEngine() {
    return this.engine;
  }

  /**
   * Run a SPARQL query and return results in the given mimetype format
   *
   * @param {string} query the SPARQL query as a string
   * @param {*} mimetype the format of the returned data
   * @returns the results of the query in the given format
   */
  select(query, mimetype) {
    switch (mimetype) {
      case 'text/tab-separated-values':
        return this.selectTsv(query);
      case 'text/csv':
        return this.selectCsv(query);
      default:
        throw new Error(`MIME Type: ${mimetype} not supported by this method.`);
    }
  }

  /**
   * Generator that returns SPARQL query results as simple objects
   *
   * @param {string} query the SPARQL query as a string
   */
  *selectObjects(query) {
    for (const datum of this.engine.query(query)) {
      const result = {};
      datum.forEach((node, key) => {
        result[key] = nodeValue(node);
      });
      yield result;
    }
  }

  /**
   * Run a SPARQL query and return results in csv format
   *
   * @param {string} query the SPARQL query as a string
   * @returns the results of the query in csv format
   */
  selectCsv(query) {
    const data = Array.from(this.selectObjects(query));
    return Papa.unparse(data);
  }

  /**
   * Run a SPARQL query and return results in tsv format
   *
   * @param {string} query the SPARQL query as a string
   * @returns the results of the query in tsv format
   */
  selectTsv(query) {
    let fields, output;
    for (const datum of this.engine.query(query)) {
      if (!fields) {
        fields = [...datum.keys()];
        output = fields.join('\t') + '\n';
      }
      const row = fields.map((f) => nodeValue(datum.get(f))).filter((v) => v);
      output += row.join('\t') + '\n';
    }
    return output;
  }

  async selectRemote(query, sparqlEndpoint) {
    const fetcher = new SparqlEndpointFetcher({});
    const stream = await fetcher.fetchBindings(sparqlEndpoint, query);
    return new Promise((resolve, reject) => {
      const results = [];
      stream.on('data', (bindings) => {
        const result = Object.keys(bindings).reduce(
          (acc, key) => ((acc[key] = bindings[key]?.value), acc),
          {}
        );
        results.push(result);
      });
      stream.on('end', () => {
        resolve(results);
      });
    });
  }

  async selectCsvRemote(query, sparqlEndpoint) {
    const data = await this.selectRemote(query, sparqlEndpoint);
    return Papa.unparse(data);
  }
}
