 #include<stdio.h>
#include <stdlib.h>
int i,j;
struct process{
	int priority;
	int burst_time;
	int pid;
	int waiting_time;
	int turnaround_time;
	int remaining_time;
	int arrival_time;
};
//Functions
void Input();
void findWaitingTime(struct process *q,int);
void findTurnAroundTime(struct process *q,int);
void printQueue(struct process *q,int size);
void RoundRobin();
void PrioSort();
void FCFS();
//Queues
int q1_n=0,q2_n=0,q3_n=0,n=0; //N=Total Process
struct process *q1,*q2,*q3;
//Time Quantum
int time_quantum = 4;

void Input(){
	printf("\n Enter the Total Number of Process:\t");
	scanf("%d",&n);
	//Allocatig Memory
	q1 = (struct process *)malloc(n*sizeof(struct process));
	q2 = (struct process *)malloc(n*sizeof(struct process));
	q3 = (struct process *)malloc(n*sizeof(struct process));
	for(i=0;i<n;i++){
		struct process p;
		printf("\n\t\tProcess %d\n=============================================\n\n",i+1);
		printf("\n Please enter the Arrival Time, Burst Time, and Priority for each process \n");
		scanf("%d",&p.arrival_time);
		p.pid = i+1;
		scanf("%d",&p.burst_time);
		scanf("%d",&p.priority);

		printf("\nPId:\t%d",p.pid);
		printf("\nPriority (1-9):\t%d",p.priority);
		printf("\nBurst Time: %d\t",p.burst_time);
		p.remaining_time = p.burst_time;
		if(p.priority>0 && p.priority<=3){
			q1[q1_n++]  = p;
		}
        else if(p.priority>3 && p.priority<=6){
			q2[q2_n++] = p;
		}else{
			q3[q3_n++] = p;
		}
	}
}
void printQueue(struct process *q,int size){
	findWaitingTime(q,size);
	findTurnAroundTime(q,size);
	printf("\nPId\t\tPriority\t\tBurst Time\t\tWaiting Time\t\tTurnAround Time\t\tArrival Time");
	printf("\n===================================================================================================================\n");
	for(i=0;i<size;i++){
		struct process p = q[i];
			printf("\n%d\t\t%d\t\t\t%d\t\t\t%d\t\t\t%d\t\t\t\t%d",p.pid,p.priority,p.burst_time,p.waiting_time,p.turnaround_time,p.arrival_time);
	}
	printf("\n\n");
}
void findWaitingTime(struct process *q,int size){
	q[0].waiting_time = 0;
	int burst_sum=0;
	for(i=1;i<size;i++){
		burst_sum+=q[i-1].burst_time;
		q[i].waiting_time = (q[1].arrival_time + burst_sum)- q[i].arrival_time;
	}
}
void findTurnAroundTime(struct process *q,int size){
	q[0].waiting_time = 0;
	for(i=0;i<size;i++){

		q[i].turnaround_time = q[i].waiting_time + q[i].burst_time;
	}
}
void RoundRobinAlgo(struct process *q,int size){
	int time=0,i=0,remain=size,flag=0,wait_time=0,tat_time=0,total_times=0;
	for(time=0,i=0;remain!=0;i++){
		struct process p = q[i];
		if(p.remaining_time<=time_quantum && p.remaining_time>0){
			time += p.remaining_time;
			p.remaining_time = 0;
			flag = 1;
		}
		else if(p.remaining_time>time_quantum){
			p.remaining_time -= time_quantum;
			time += time_quantum;
		}
		if(p.remaining_time==0 && flag==1){
			remain--;
			printf("\n%d\t\t%d\t\t\t%d\t\t\t%d\t\t\t%d\t\t%d",p.pid,p.priority,p.burst_time,p.arrival_time,p.waiting_time,p.turnaround_time);
			flag = 0;
		}
		if(i==remain-1){
			i=0;
		}else if(q[i+1].arrival_time<=time){
			i++;
		}else{
			i=0;
		}

		q[i] = p;
	}
}
void RoundRobin(){
	printf("\n\n====================================================================================================================");
	printf("\n\t\tRound Robin\t");
	printf("\n======================================================================================================================\n\n");

	printf("\nPId\t\tPriority\t\tBurst Time\t\tArrival Time\t\tWaiting Time\t\tTurnAround Time");
	printf("\n======================================================================================================================\n");
	findWaitingTime(q3,q3_n);
	findTurnAroundTime(q3,q3_n);

	RoundRobinAlgo(q3,q3_n);
}
void PrioSortingAlgorithm(struct process *q,int size){
	for(i=0;i<size;i++){
		for(j=0;j<size;j++){
			if(q[j].priority>q[i].priority){
				struct process t = q[i];
				q[i] = q[j];
				q[j] = t;
			}
		}
	}
}
void PrioSort(){
	printf("\n\n===================================================================================================================");
	printf("\n\t\tPriority Sorting\t");
	printf("\n=====================================================================================================================\n\n");
	PrioSortingAlgorithm(q2,q2_n);
	printQueue(q2,q2_n);
}
void FCFSAlgorithm(struct process *q,int size){
	for(i=0;i<size;i++){
		for(j=0;j<size;j++){
			if(q[j].arrival_time>q[i].arrival_time){
				struct process t = q[i];
				q[i] = q[j];
				q[j] = t;
			}
		}
	}
}
void FCFS(){
	printf("\n\n====================================================================================================================");
	printf("\n\t\tFirst Come First Serve\t");
	printf("\n======================================================================================================================\n\n");
	FCFSAlgorithm(q1,q1_n);
	printQueue(q1,q1_n);
}
int main()
{
	Input();
	int i=1;
	while(n>0){
		switch(i){
			case 3:
				RoundRobin();
				break;
			case 2:
				PrioSort();
				break;
			case 1:
				FCFS();
				break;
		}
		i++;
	}
	printf("\n\n");
	return 0;
}
