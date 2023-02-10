import 'package:flutter/material.dart';
import 'package:tourapp/components/banner_image.dart';
import 'models/location.dart';
import 'components/location_tile.dart';
import 'components/default_app_bar.dart';
import 'styles.dart';

const BannerImageHeight = 300.0;
const BodyVerticalPadding = 20.0;
const FooterHeight = 100.0;
const renderBodyBottomPadding = 100.0;

class LocationDetail extends StatefulWidget {
  final int locationID;

  LocationDetail(this.locationID);

  @override
  createState() => _LocationDetailState(this.locationID);
}

class _LocationDetailState extends State<LocationDetail> {
  final int locationID;
  Location location = Location.blank();

  _LocationDetailState(this.locationID);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(),
        body: Stack(children: [
          _renderBody(context, location),
          _renderFooter(context, location)
        ]));
  }

  loadData() async {
    final location = await Location.fetchByID(this.locationID);

    if (mounted) {
      setState(() {
        this.location = location;
      });
    }
  }

  Widget _renderBody(BuildContext context, Location location) {
    var result = <Widget>[];
    result.add(BannerImage(url: location.url, height: BannerImageHeight));
    result.add(_renderHeader());
    result.addAll(_renderFacts(context, location));
    return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: renderBodyBottomPadding),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: result));
  }

  Widget _renderHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: BodyVerticalPadding,
          horizontal: Styles.horizontalPaddingDefault),
      child: LocationTile(location, false),
    );
  }

  List<Widget> _renderFacts(BuildContext context, Location location) {
    var result = <Widget>[];
    for (int i = 0; i < (location.facts ?? []).length; i++) {
      result.add(_sectionTitle(location.facts![i].title));
      result.add(_sectionText(location.facts![i].text));
    }
    return result;
  }

  Widget _sectionTitle(String text) {
    return Container(
        padding: EdgeInsets.fromLTRB(Styles.horizontalPaddingDefault, 25.0,
            Styles.horizontalPaddingDefault, 0.0),
        child: Text(text.toUpperCase(),
            textAlign: TextAlign.left, style: Styles.headerLarge));
  }

  Widget _sectionText(String text) {
    return Container(
        padding: EdgeInsets.symmetric(
            vertical: 10.0, horizontal: Styles.horizontalPaddingDefault),
        child: Text(text, style: Styles.textDefault));
  }

  Widget _renderFooter(BuildContext context, Location location) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
          height: FooterHeight,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            child: _renderBookButton(),
          ),
        )
      ],
    );
  }

  Widget _renderBookButton() {
    return TextButton(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
      onPressed: () {},
      child: Text('Book'.toUpperCase(), style: Styles.textCTAButton),
    );
  }
}
