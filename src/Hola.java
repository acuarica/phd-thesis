import java.util.List;

public class Hola {
    public static void main(String[] args) {
        System.out.println("Hello");

        Object o = new StudentsPerformanceReport();
        System.out.println(o);
    }

    public static abstract class StudentsPerformanceReport_Base {
        public String getValue(StudentsPerformanceReport o1) {
            return ((StudentsPerformanceReport_Base)o1).executionSemester.get(0);
        }

        public String getValue0(StudentsPerformanceReport o1) {
            //The field Hola.StudentsPerformanceReport_Base.executionSemester is not visibleJava(33554503)
            // return o1.executionSemester.get(0);
            return null;
        }

        public String getValue1(StudentsPerformanceReport o1) { 
            StudentsPerformanceReport_Base o2 = o1;
            return o2.executionSemester.get(0);
        }

        private List<String> executionSemester;
    }
    
    public static class StudentsPerformanceReport extends StudentsPerformanceReport_Base {

    }

}