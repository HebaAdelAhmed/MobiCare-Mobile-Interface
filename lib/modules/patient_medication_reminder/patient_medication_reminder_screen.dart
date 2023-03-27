import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:mobi_care/modules/patient_medication_reminder/cubit/cubit.dart';
import 'package:mobi_care/modules/patient_medication_reminder/cubit/states.dart';
import 'package:mobi_care/shared/components/components.dart';
import 'package:mobi_care/shared/styles/colors.dart';

class PatientMedicationReminderScreen extends StatelessWidget {
  PatientMedicationReminderScreen({Key? key}) : super(key: key);

  TextEditingController medicineNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime ? dateTime;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientMedicationReminderCubit , PatientMedicationReminderStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        PatientMedicationReminderCubit cubit = PatientMedicationReminderCubit.get(context);
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0
          ),
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/svg/medication_reminder/medication_reminder.svg'),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'You can set an alarm for medication appointments',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: InkWell(
                      onTap: (){
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: SingleChildScrollView(
                                  child: Container(
                                    color: primaryWhiteColor,
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          color: primaryColor1BA,
                                          child: TimePickerSpinner(
                                            is24HourMode: false,
                                            normalTextStyle: TextStyle(
                                              color: primaryWhiteColor.withOpacity(0.5),
                                              fontWeight: FontWeight.w300,
                                              fontSize: 22,
                                            ),
                                            highlightedTextStyle: TextStyle(
                                              color: primaryWhiteColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 23,
                                            ),
                                            spacing: 40,
                                            itemHeight: 60,
                                            time: DateTime.now(),
                                            isForce2Digits: true,
                                            onTimeChange: (time){
                                              dateTime = time;
                                              cubit.changeDateTime(time);
                                            },

                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: medicineNameController,
                                          decoration: InputDecoration(
                                            hintText: 'Medicine name',
                                            hintStyle: TextStyle(
                                              color: primaryWhiteColor.withOpacity(0.7),
                                            ),
                                            filled: true,
                                            fillColor: primaryColor1BA,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                              borderSide: BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          maxLines: 3,
                                          controller: descriptionController,
                                          decoration: InputDecoration(
                                            hintText: 'Description',
                                            hintStyle: TextStyle(
                                              color: primaryWhiteColor.withOpacity(0.7),
                                            ),
                                            filled: true,
                                            fillColor: primaryGreyColor808.withOpacity(0.3),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                              borderSide: BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        defaultButton(
                                          function: (){
                                            cubit.insertToDatabase(
                                              nameOfMedicine: medicineNameController.text,
                                              timeOfMedicine: cubit.dateTime.toString(),
                                              description: descriptionController.text ?? " ",
                                            );
                                            Navigator.pop(context);
                                          },
                                          text: 'Done',
                                          redius: 25,
                                          backgroundColor: primaryBlueColor2C8,
                                          width: 150,
                                          height: 40,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 60,
                        decoration: BoxDecoration(
                          color: primaryColor1BA.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  'Add a new medicine',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: SvgPicture.asset('assets/icons/medicines_icon.svg'),
                              ),                  ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      // physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return medicationReminderContainer(
                            name: cubit.medicines[index]['name'],
                            timeInHour: DateTime.parse(cubit.medicines[index]['time']).hour.toString(),
                            timeInMinute: DateTime.parse(cubit.medicines[index]['time']).minute.toString(),
                            isTimeAM: int.parse(DateTime.parse(cubit.medicines[index]['time']).hour.toString())<= 12 ? true : false,
                            howTimes: cubit.medicines[index]['description'],
                        );
                      } ,
                      itemCount: cubit.medicines.length,
                      // physics: const NeverScrollableScrollPhysics(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
