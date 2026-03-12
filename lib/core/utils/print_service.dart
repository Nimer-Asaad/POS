import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:drift/drift.dart';

import '../../data/db/app_database.dart';

class PrintService {
  final AppDatabase db;

  PrintService(this.db);

  String _formatCents(int cents) {
    final sign = cents < 0 ? '-' : '';
    final amount = cents.abs();
    final dollars = amount ~/ 100;
    final remainder = amount % 100;
    return '$sign\$$dollars.${remainder.toString().padLeft(2, '0')}';
  }

  /// Build sale invoice PDF for preview
  Future<Uint8List> buildSaleInvoicePdf(String saleId) async {
    final sale = await db.getSaleById(saleId);
    if (sale == null) {
      throw StateError('Sale not found: $saleId');
    }

    final items = await db.getSaleItems(saleId);

    // Fetch service transactions linked to this sale
    final serviceRows = await db.getServiceTransactionsForSale(saleId);

    final serviceItems = serviceRows
        .map(
          (service) => _ServiceLineItem(
            providerLabel: service.providerLabel ?? 'Service',
            amountCents: service.amountCents,
          ),
        )
        .toList();

    final subtotal =
        items.fold<int>(0, (sum, item) => sum + item.saleItem.lineTotal) +
        serviceItems.fold<int>(0, (sum, service) => sum + service.amountCents);
    final change = sale.paymentType == 'Cash'
        ? (sale.paid > sale.total ? sale.paid - sale.total : 0)
        : 0;

    // Load Arabic font for proper rendering
    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final arabicFontBold = await PdfGoogleFonts.cairoBold();

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'فاتورة بيع - Sale Invoice',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Divider(),
                pw.SizedBox(height: 4),
                pw.Text('Date: ${sale.createdAt}'),
                pw.Text('Invoice ID: ${sale.id}'),
                pw.SizedBox(height: 12),
                if (items.isNotEmpty) ...[
                  pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.grey400),
                    children: [
                      pw.TableRow(
                        decoration: pw.BoxDecoration(color: PdfColors.grey300),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(
                              'Name',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(
                              'Qty',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(
                              'Price',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(
                              'Total',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...items.map(
                        (item) => pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text(item.product.name),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text(item.saleItem.qty.toString()),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text(
                                _formatCents(item.saleItem.unitPrice),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text(
                                _formatCents(item.saleItem.lineTotal),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                if (serviceItems.isNotEmpty) ...[
                  pw.SizedBox(height: 12),
                  pw.Text(
                    'Services - الخدمات:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.grey400),
                    children: [
                      pw.TableRow(
                        decoration: pw.BoxDecoration(color: PdfColors.grey300),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(
                              'Service',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(
                              'Amount',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...serviceItems.map(
                        (service) => pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text(service.providerLabel),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text(_formatCents(service.amountCents)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                pw.SizedBox(height: 12),
                pw.Divider(),
                _totalsRow('Subtotal:', _formatCents(subtotal)),
                _totalsRow('Discount:', _formatCents(sale.discount)),
                pw.Divider(),
                _totalsRow('Total:', _formatCents(sale.total)),
                pw.SizedBox(height: 8),
                _totalsRow('Paid:', _formatCents(sale.paid)),
                _totalsRow('Change:', _formatCents(change)),
                _totalsRow('Payment type:', sale.paymentType),
                pw.Spacer(),
                pw.Divider(),
                pw.SizedBox(height: 8),
                pw.Center(child: pw.Text('Thank You - شكراً لك')),
              ],
            ),
          );
        },
      ),
    );

    return doc.save();
  }

  /// Build repair receipt PDF for preview
  Future<Uint8List> buildRepairReceiptPdf(String repairId) async {
    final repair = await db.getRepairById(repairId);
    if (repair == null) {
      throw StateError('Repair not found: $repairId');
    }

    // Load Arabic font for proper rendering
    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final arabicFontBold = await PdfGoogleFonts.cairoBold();

    final compactDate = repair.createdAt.toString().split('.')[0];
    final compactRepairId = repair.id.length > 12
        ? repair.id.substring(0, 12)
        : repair.id;

    const stickerWidth = 7.2 * PdfPageFormat.cm;
    const stickerHeight = 5.1 * PdfPageFormat.cm;

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) {
          return pw.Align(
            alignment: pw.Alignment.topLeft,
            child: pw.Container(
              width: stickerWidth,
              height: stickerHeight,
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black, width: 1),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text(
                    'Repair Sticker',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'Date: $compactDate',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                  pw.Text(
                    'ID: $compactRepairId',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    'Customer: ${repair.customerName}',
                    style: const pw.TextStyle(fontSize: 8),
                    maxLines: 1,
                    overflow: pw.TextOverflow.clip,
                  ),
                  if (repair.customerPhone != null &&
                      repair.customerPhone!.trim().isNotEmpty)
                    pw.Text(
                      'Phone: ${repair.customerPhone}',
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'Device: ${repair.device} ${repair.model ?? ''}',
                    style: const pw.TextStyle(fontSize: 8),
                    maxLines: 1,
                    overflow: pw.TextOverflow.clip,
                  ),
                  if (repair.imei != null && repair.imei!.trim().isNotEmpty)
                    pw.Text(
                      'IMEI: ${repair.imei}',
                      style: const pw.TextStyle(fontSize: 8),
                      maxLines: 1,
                      overflow: pw.TextOverflow.clip,
                    ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'Issue: ${repair.issue}',
                    style: const pw.TextStyle(fontSize: 8),
                    maxLines: 2,
                    overflow: pw.TextOverflow.clip,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    return doc.save();
  }

  /// Build delivery receipt PDF for when repair is finalized and delivered
  Future<Uint8List> buildDeliveryReceiptPdf(String repairId) async {
    final repair = await db.getRepairById(repairId);
    if (repair == null) {
      throw StateError('Repair not found: $repairId');
    }

    final parts = await db.getRepairParts(repairId);

    final partsTotal = parts.fold<int>(
      0,
      (sum, p) => sum + (p.repairPart.unitPrice * p.repairPart.qty),
    );
    final totalPaid = repair.paidAtReceive + repair.paidAtDelivery;
    final finalCost = repair.finalCost > 0
        ? repair.finalCost
        : repair.estimatedCost;
    final afterDiscount = finalCost - repair.discount;
    final remaining = afterDiscount - totalPaid;

    // Load Arabic font
    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final arabicFontBold = await PdfGoogleFonts.cairoBold();

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'Delivery Receipt - وصل تسليم',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Divider(),
                pw.SizedBox(height: 12),
                pw.Text('Date: ${DateTime.now().toString().split('.')[0]}'),
                pw.Text('Repair ID: ${repair.id}'),
                pw.SizedBox(height: 12),
                pw.Text(
                  'Customer: ${repair.customerName}',
                  style: pw.TextStyle(fontSize: 14),
                ),
                if (repair.customerPhone != null)
                  pw.Text('Phone: ${repair.customerPhone}'),
                pw.SizedBox(height: 12),
                pw.Text('Device: ${repair.device}'),
                pw.Text('Model: ${repair.model ?? '-'}'),
                pw.Text('IMEI: ${repair.imei ?? '-'}'),
                pw.SizedBox(height: 12),
                pw.Divider(),
                pw.SizedBox(height: 8),
                if (parts.isNotEmpty) ...[
                  pw.Text(
                    'Parts Used:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Table.fromTextArray(
                    headers: const ['Part', 'Qty', 'Price'],
                    data: parts
                        .map(
                          (item) => [
                            item.product.name,
                            item.repairPart.qty.toString(),
                            _formatCents(item.repairPart.unitPrice),
                          ],
                        )
                        .toList(),
                    headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    cellAlignment: pw.Alignment.centerLeft,
                    cellHeight: 20,
                  ),
                  pw.SizedBox(height: 8),
                  _totalsRow('Parts Total:', _formatCents(partsTotal)),
                  pw.SizedBox(height: 4),
                ],
                pw.Divider(),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Payment Summary:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 4),
                _totalsRow(
                  'Labor/Service Cost:',
                  _formatCents(repair.estimatedCost),
                ),
                if (parts.isNotEmpty)
                  _totalsRow('Parts Cost:', _formatCents(partsTotal)),
                if (repair.finalCost > 0)
                  _totalsRow('Final Cost:', _formatCents(repair.finalCost)),
                if (repair.discount > 0) ...[
                  _totalsRow('Discount:', '-${_formatCents(repair.discount)}'),
                  pw.Divider(),
                ],
                _totalsRow(
                  'Total After Discount:',
                  _formatCents(afterDiscount),
                ),
                pw.SizedBox(height: 8),
                pw.Divider(),
                _totalsRow(
                  'Paid at Receive:',
                  _formatCents(repair.paidAtReceive),
                ),
                _totalsRow(
                  'Paid at Delivery:',
                  _formatCents(repair.paidAtDelivery),
                ),
                pw.Divider(),
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 1),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Column(
                    children: [
                      _totalsRow('Total Paid:', _formatCents(totalPaid)),
                      if (remaining != 0) ...[
                        pw.SizedBox(height: 4),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              remaining > 0
                                  ? 'Remaining Balance:'
                                  : 'Overpaid:',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              _formatCents(remaining.abs()),
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                pw.Spacer(),
                pw.Divider(),
                pw.SizedBox(height: 8),
                pw.Center(child: pw.Text('Thank You - شكراً لك')),
                pw.SizedBox(height: 4),
                pw.Center(
                  child: pw.Text(
                    'Status: ${repair.status}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return doc.save();
  }

  /// Build payment receipt PDF for debt payments
  Future<Uint8List> buildPaymentReceiptPdf({
    required String customerName,
    String? customerPhone,
    required int paymentAmount,
    required int remainingBalance,
    List? clearedDebts,
    String? note,
  }) async {
    // Load Arabic font
    final arabicFont = await PdfGoogleFonts.cairoRegular();
    final arabicFontBold = await PdfGoogleFonts.cairoBold();

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: arabicFontBold),
        build: (context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'Payment Receipt - وصل دفع',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Divider(),
                pw.SizedBox(height: 12),
                pw.Text('Date: ${DateTime.now().toString().split('.')[0]}'),
                pw.SizedBox(height: 12),
                pw.Text(
                  'Customer: $customerName',
                  style: pw.TextStyle(fontSize: 14),
                ),
                if (customerPhone != null && customerPhone.isNotEmpty)
                  pw.Text('Phone: $customerPhone'),
                pw.SizedBox(height: 16),
                pw.Divider(),
                pw.SizedBox(height: 8),
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 2),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Amount Paid:',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            _formatCents(paymentAmount),
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 12),
                if (clearedDebts != null && clearedDebts.isNotEmpty) ...[
                  pw.Text(
                    'Applied to Debts:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 4),
                  ...clearedDebts.map(
                    (debt) => pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 2),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            '${debt.sourceType.toUpperCase()} - ${debt.sourceId}',
                          ),
                          pw.Text(_formatCents(debt.amount)),
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 8),
                ],
                pw.Divider(),
                pw.SizedBox(height: 8),
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Remaining Balance:',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        _formatCents(remainingBalance),
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
                          color: remainingBalance > 0
                              ? PdfColors.red
                              : PdfColors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                if (note != null && note.isNotEmpty) ...[
                  pw.SizedBox(height: 16),
                  pw.Text(
                    'Note:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(note),
                ],
                pw.Spacer(),
                pw.Divider(),
                pw.SizedBox(height: 8),
                pw.Center(child: pw.Text('Thank You - شكراً لك')),
                pw.SizedBox(height: 4),
                pw.Center(
                  child: pw.Text(
                    remainingBalance == 0
                        ? 'All debts cleared! - تم سداد جميع الديون!'
                        : 'Partial payment received - تم استلام دفعة جزئية',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return doc.save();
  }

  pw.Widget _totalsRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [pw.Text(label), pw.Text(value)],
      ),
    );
  }

  // Print methods
  Future<void> printSaleInvoice(String saleId) async {
    final pdfBytes = await buildSaleInvoicePdf(saleId);
    await Printing.layoutPdf(onLayout: (_) => pdfBytes);
  }

  Future<void> printRepairReceipt(String repairId) async {
    final pdfBytes = await buildRepairReceiptPdf(repairId);
    await Printing.layoutPdf(onLayout: (_) => pdfBytes);
  }

  Future<void> printDeliveryReceipt(String repairId) async {
    final pdfBytes = await buildDeliveryReceiptPdf(repairId);
    await Printing.layoutPdf(onLayout: (_) => pdfBytes);
  }

  Future<void> printPaymentReceipt({
    required String customerName,
    String? customerPhone,
    required int paymentAmount,
    required int remainingBalance,
    List? clearedDebts,
    String? note,
  }) async {
    final pdfBytes = await buildPaymentReceiptPdf(
      customerName: customerName,
      customerPhone: customerPhone,
      paymentAmount: paymentAmount,
      remainingBalance: remainingBalance,
      clearedDebts: clearedDebts,
      note: note,
    );
    await Printing.layoutPdf(onLayout: (_) => pdfBytes);
  }
}

class _ServiceLineItem {
  final String providerLabel;
  final int amountCents;

  const _ServiceLineItem({
    required this.providerLabel,
    required this.amountCents,
  });
}
