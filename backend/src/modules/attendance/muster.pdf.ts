import PDFDocument from 'pdfkit';
import { MUSTER_LEGEND, type MusterRow } from './muster.policy';

/**
 * Prints the muster roll on A4 landscape: code, name, one narrow column per day, totals, and
 * the legend. Names are printed in English (the built-in PDF fonts have no Devanagari; the CSV
 * keeps Marathi). Runs on our server: no external service.
 */
export function renderMusterPdf(
  title: string,
  days: readonly string[],
  rows: readonly MusterRow[],
): Promise<Buffer> {
  return new Promise((resolve, reject) => {
    const doc = new PDFDocument({ size: 'A4', layout: 'landscape', margin: 24 });
    const chunks: Buffer[] = [];
    doc.on('data', (c: Buffer) => chunks.push(c));
    doc.on('end', () => resolve(Buffer.concat(chunks)));
    doc.on('error', reject);

    const left = doc.page.margins.left;
    const codeW = 58;
    const nameW = 112;
    const dayW = Math.min(18, (doc.page.width - left * 2 - codeW - nameW - 4 * 26) / days.length);
    const totW = 26;
    const rowH = 12;
    const bottom = doc.page.height - doc.page.margins.bottom - rowH * 2;

    const header = () => {
      doc.font('Helvetica-Bold').fontSize(11).text(title, left, doc.page.margins.top);
      let x = left;
      const y = doc.y + 4;
      doc.fontSize(6.5);
      doc.text('Code', x, y, { width: codeW });
      x += codeW;
      doc.text('Name', x, y, { width: nameW });
      x += nameW;
      for (const d of days) {
        doc.text(d.slice(8), x, y, { width: dayW, align: 'center' });
        x += dayW;
      }
      for (const label of ['Pres.', 'Abs.', 'Leave', 'Late']) {
        doc.text(label, x, y, { width: totW, align: 'center' });
        x += totW;
      }
      doc
        .moveTo(left, y + rowH - 2)
        .lineTo(x, y + rowH - 2)
        .lineWidth(0.5)
        .stroke();
      return y + rowH;
    };

    let y = header();
    doc.font('Helvetica').fontSize(6.5);
    for (const r of rows) {
      if (y > bottom) {
        doc.addPage();
        y = header();
        doc.font('Helvetica').fontSize(6.5);
      }
      let x = left;
      doc.text(r.employeeCode, x, y, { width: codeW, lineBreak: false });
      x += codeW;
      doc.text(r.name, x, y, { width: nameW - 4, lineBreak: false, ellipsis: true });
      x += nameW;
      for (const c of r.cells) {
        doc.fillColor(c === 'A' ? '#b91c1c' : c === '-' ? '#94a3b8' : '#000000');
        doc.text(c, x, y, { width: dayW, align: 'center', lineBreak: false });
        x += dayW;
      }
      doc.fillColor('#000000');
      for (const v of [r.presentDays, r.absentDays, r.leaveDays, r.lateDays]) {
        doc.text(String(v), x, y, { width: totW, align: 'center', lineBreak: false });
        x += totW;
      }
      y += rowH;
    }
    doc
      .fontSize(7)
      .text(
        MUSTER_LEGEND.map((l) => `${l.code} = ${l.en}`).join('    '),
        left,
        Math.min(y + 6, bottom + rowH),
      );
    doc.end();
  });
}
