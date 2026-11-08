import 'dart:ui';

import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../ui/design.dart';

class GoldView extends StatefulWidget {
  const GoldView({super.key});
  @override
  State<GoldView> createState() => _GoldViewState();
}

class _GoldViewState extends State<GoldView> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final locked = !s.gold && selected == 0;
    return Column(
      children: [
        Row(
          children: List.generate(
            2,
            (i) => Expanded(
              child: InkWell(
                onTap: () => setState(() => selected = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: i == selected ? pink : line,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    i == 0 ? 'Who like you' : 'Top selection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: i == selected ? ink : muted,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            selected == 0
                ? 'Upgrade to Gold User to see who likes you!'
                : 'Upgrade to Gold User to see more Top selections!',
            style: const TextStyle(fontSize: 10, color: muted),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 12,
                  childAspectRatio: .68,
                ),
                itemCount: people.length,
                itemBuilder: (c, i) {
                  final p =
                      people[(i + (selected == 1 ? 4 : 0)) % people.length];
                  return GestureDetector(
                    onTap: () => locked
                        ? showGoldSheet(context)
                        : open(context, '/person', p),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: line),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: locked ? 9 : 0,
                                sigmaY: locked ? 9 : 0,
                              ),
                              child: photo(p.image, width: double.infinity),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (locked) ...[
                            Container(
                              width: 80,
                              height: 6,
                              color: pink.withValues(alpha: .4),
                            ),
                            const SizedBox(height: 8),
                            Container(width: 55, height: 4, color: line),
                          ] else ...[
                            Text(p.title, style: const TextStyle(fontSize: 11)),
                            const SizedBox(height: 4),
                            Text(
                              '⌖ ${p.distance}km away',
                              style: const TextStyle(
                                fontSize: 10,
                                color: muted,
                              ),
                            ),
                          ],
                          const SizedBox(height: 14),
                        ],
                      ),
                    ),
                  );
                },
              ),
              if (locked)
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 20,
                  child: BrandButton(
                    'Upgrade to Gold User',
                    () => showGoldSheet(context),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

const plans = [
  '3 months (\$15 for each month)',
  '6 months (\$12 for each month)',
  '12 months (\$10 for each month)',
];
void showGoldSheet(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.white,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  ),
  builder: (c) => const GoldSheet(),
);

class GoldSheet extends StatelessWidget {
  const GoldSheet({super.key});
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Buy Gold User',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose type',
              style: TextStyle(fontSize: 11, color: muted),
            ),
            DropdownButtonFormField<int>(
              initialValue: s.plan,
              isExpanded: true,
              items: List.generate(
                3,
                (i) => DropdownMenuItem(
                  value: i,
                  child: Text(
                    plans[i],
                    style: const TextStyle(color: gold, fontSize: 12),
                  ),
                ),
              ),
              onChanged: (v) => s.update(() => s.plan = v!),
            ),
            const SizedBox(height: 18),
            const Center(
              child: Text(
                'Saving 41% (most popular)',
                style: TextStyle(color: pink, fontSize: 13),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Demo checkout. No real charge or subscription will be created.',
              textAlign: TextAlign.center,
              style: TextStyle(color: muted, fontSize: 11),
            ),
            const SizedBox(height: 20),
            BrandButton('Continue', () {
              Navigator.pop(context);
              open(context, '/payment');
            }),
          ],
        ),
      ),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context),
        months = [3, 6, 12][AppScope.of(context).plan];
    final rate = [15, 12, 10][s.plan];
    return PageFrame(
      'Payment Methods',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('Bill detail'),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(border: Border.all(color: line)),
            child: Column(
              children: [
                const Text(
                  'Boobe Gold',
                  style: TextStyle(fontSize: 12, color: muted),
                ),
                const SizedBox(height: 16),
                photo('logo', width: 80),
                const SizedBox(height: 10),
                const Text('Boobe'),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Gold User $months months',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Text('\$$rate/month'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const Text('Total'), Text('\$${months * rate}')],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'DEMO PAYMENT',
            style: TextStyle(color: pink, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          const Text(
            'This is a local preview of the payment screen. Use the sample details below; card data is never collected.',
            style: TextStyle(fontSize: 11, color: muted),
          ),
          const SizedBox(height: 18),
          const _SampleField('Account name', 'Tony Stark'),
          const _SampleField('Card number', '4242 4242 4242 4242'),
          const Row(
            children: [
              Expanded(child: _SampleField('Valid from', '01/26')),
              SizedBox(width: 18),
              Expanded(child: _SampleField('Valid thru', '12/30')),
            ],
          ),
          const _SampleField('CCV', '•••'),
          const SizedBox(height: 22),
          BrandButton('Accept · Demo payment', () {
            s.update(() {
              s.gold = true;
              s.tab = 2;
            });
            home(context);
            notice(context, 'Gold preview unlocked. No payment was made.');
          }),
        ],
      ),
    );
  }
}

class _SampleField extends StatelessWidget {
  const _SampleField(this.label, this.value);
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: InputDecorator(
      decoration: InputDecoration(labelText: label),
      child: Text(value, style: const TextStyle(fontSize: 13, color: muted)),
    ),
  );
}
